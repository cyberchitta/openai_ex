defmodule OpenaiEx.HttpSse do
  @moduledoc false
  alias OpenaiEx.Http
  require Logger

  # based on
  # https://gist.github.com/zachallaun/88aed2a0cef0aed6d68dcc7c12531649
  # and
  # https://html.spec.whatwg.org/multipage/server-sent-events.html#parsing-an-event-stream

  def post(openai = %OpenaiEx{}, url, json: json) do
    me = self()
    ref = make_ref()
    task = Task.async(fn -> post_sse(openai, url, json, me, ref) end)
    status = receive(do: ({:chunk, {:status, status}, ^ref} -> status))
    headers = receive(do: ({:chunk, {:headers, headers}, ^ref} -> headers))

    if status in 200..299 do
      body_stream = Stream.resource(fn -> {"", ref} end, &next_sse/1, fn _ -> :ok end)
      %{status: status, headers: headers, body_stream: body_stream, task_pid: task.pid}
    else
      error_message = collect_error_message(ref, "")
      %{status: status, headers: headers, error: Jason.decode!(error_message)}
    end
  end

  def cancel_request(task_pid) when is_pid(task_pid) do
    send(task_pid, :cancel_request)
  end

  defp post_sse(openai = %OpenaiEx{}, url, json, me, ref) do
    request = OpenaiEx.Http.build_post(openai, url, json: json)
    on_chunk = create_chunk_handler(me, ref)
    options = Http.request_options(openai)
    request |> Finch.stream(Map.get(openai, :finch_name), nil, on_chunk, options)
    send(me, {:done, ref})
  end

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

  defp next_sse({acc, ref}) do
    receive do
      {:chunk, {:data, evt_data}, ^ref} ->
        {events, next_acc} = extract_events(evt_data, acc)
        {[events], {next_acc, ref}}

      # some 3rd party providers seem to be ending the stream with eof,
      # rather than 2 line terminators. Hopefully those will be fixed and this
      # can be removed in the future
      {:done, ^ref} when acc == "data: [DONE]" ->
        {:halt, {acc, ref}}

      {:done, ^ref} ->
        if acc != "", do: Logger.error("residual!: #{acc}")
        {:halt, {acc, ref}}

      {:canceled, ^ref} ->
        Logger.info("Request canceled by user")
        {:halt, {acc, ref}}
    end
  end

  @double_eol ~r/(\r?\n|\r){2}/
  @double_eol_eos ~r/(\r?\n|\r){2}$/

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

  defp extract_lines(data) do
    lines = String.split(data, @double_eol)
    incomplete_line = !Regex.match?(@double_eol_eos, data)
    if incomplete_line, do: lines |> List.pop_at(-1), else: {"", lines}
  end

  defp process_fields(lines) do
    lines
    |> Enum.map(&extract_field/1)
    |> Enum.filter(fn
      %{data: "[DONE]"} -> false
      %{data: _} -> true
      %{eventType: "done\ndata: [DONE]"} -> false
      %{eventType: _} -> true
      _ -> false
    end)
    |> Enum.map(fn
      %{data: data} ->
        %{data: Jason.decode!(data)}

      %{eventType: value} ->
        [event_id, data] = String.split(value, "\ndata: ", parts: 2)
        %{event: event_id, data: Jason.decode!(data)}
    end)
  end

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

  defp collect_error_message(ref, acc) do
    receive do
      {:chunk, {:data, chunk}, ^ref} ->
        collect_error_message(ref, acc <> chunk)

      {:done, ^ref} ->
        acc
    end
  end
end
