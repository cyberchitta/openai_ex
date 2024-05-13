defmodule OpenaiEx.HttpSse do
  @moduledoc false
  alias OpenaiEx.Http
  require Logger

  # based on
  # https://gist.github.com/zachallaun/88aed2a0cef0aed6d68dcc7c12531649
  # and
  # https://html.spec.whatwg.org/multipage/server-sent-events.html#parsing-an-event-stream

  @doc false
  def post(openai = %OpenaiEx{}, url, json: json) do
    request = OpenaiEx.Http.build_post(openai, url, json: json)

    me = self()
    ref = make_ref()

    task =
      Task.async(fn ->
        on_chunk = create_chunk_handler(me, ref)
        options = Http.request_options(openai)
        request |> Finch.stream(Map.get(openai, :finch_name), nil, on_chunk, options)
        send(me, {:done, ref})
      end)

    status = receive(do: ({:chunk, {:status, status}, ^ref} -> status))
    headers = receive(do: ({:chunk, {:headers, headers}, ^ref} -> headers))

    body_stream =
      Stream.resource(fn -> {"", ref, task} end, &next_sse/1, fn {_data, _ref, task} ->
        Task.shutdown(task)
      end)

    %{task_pid: task.pid, status: status, headers: headers, body_stream: body_stream}
  end

  @doc false
  def cancel_request(task_pid) when is_pid(task_pid) do
    send(task_pid, :cancel_request)
  end

  @doc false
  defp create_chunk_handler(me, ref) do
    fn chunk, _acc ->
      receive do
        :cancel_request ->
          send(me, {:canceled, ref})
          throw(:cancel_request)
      after
        0 -> send(me, {:chunk, chunk, ref})
      end
    end
  end

  @doc false
  defp next_sse({acc, ref, task}) do
    receive do
      {:chunk, {:data, evt_data}, ^ref} ->
        {events, next_acc} = extract_events(evt_data, acc)
        {[events], {next_acc, ref, task}}

      # some 3rd party providers seem to be ending the stream with eof,
      # rather than 2 line terminators. Hopefully those will be fixed and this
      # can be removed in the future
      {:done, ^ref} when acc == "data: [DONE]" ->
        {:halt, {acc, ref, task}}

      {:done, ^ref} ->
        if acc != "", do: Logger.warning(inspect(Jason.decode!(acc)))
        {:halt, {acc, ref, task}}

      {:canceled, ^ref} ->
        Logger.info("Request canceled by user")
        {:halt, {acc, ref, task}}
    end
  end

  @double_eol ~r/(\r?\n|\r){2}/
  @double_eol_eos ~r/(\r?\n|\r){2}$/

  @doc false
  defp extract_events(evt_data, acc) do
    all_data = acc <> evt_data

    if Regex.match?(@double_eol, all_data) do
      {remaining, lines} = extract_lines(all_data)
      events = process_fields(lines)
      {events, remaining}
    else
      {[], all_data}
    end
  end

  @doc false
  defp extract_lines(data) do
    lines = String.split(data, @double_eol)
    incomplete_line = !Regex.match?(@double_eol_eos, data)
    if incomplete_line, do: lines |> List.pop_at(-1), else: {"", lines}
  end

  @doc false
  defp process_fields(lines) do
    lines
    |> Enum.map(&extract_field/1)
    |> Enum.filter(fn
      %{data: "[DONE]"} -> false
      %{data: _} -> true
      %{eventType: _} -> true
      _ -> false
    end)
    |> Enum.map(fn
      %{data: data} -> %{data: Jason.decode!(data)}
      token -> token
    end)
  end

  @doc false
  defp extract_field(line) do
    [field | rest] = String.split(line, ":", parts: 2)
    value = Enum.join(rest, "") |> String.replace_prefix(" ", "")

    case field do
      "data" -> %{data: value}
      "event" -> %{eventType: value}
      "id" -> %{lastEventId: value}
      "retry" -> %{retry: value}
      # comment
      _ -> nil
    end
  end
end
