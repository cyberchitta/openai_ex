defmodule OpenaiEx.HttpSse do
  @moduledoc false
  alias OpenaiEx.Http
  require Logger

  # based on
  # https://gist.github.com/zachallaun/88aed2a0cef0aed6d68dcc7c12531649

  @doc false
  def post(openai = %OpenaiEx{}, url, json: json) do
    request = OpenaiEx.Http.build_post(openai, url, json: json)

    me = self()
    ref = make_ref()

    task =
      Task.async(fn ->
        on_chunk = create_chunk_handler(me, ref)
        request |> Finch.stream(OpenaiEx.Finch, nil, on_chunk, Http.request_options(openai))
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
        {tokens, next_acc} = tokenize_data(evt_data, acc)
        {[tokens], {next_acc, ref, task}}

      {:done, ^ref} ->
        if acc != "", do: Logger.warning(inspect(Jason.decode!(acc)))
        {:halt, {acc, ref, task}}

      {:canceled, ^ref} ->
        Logger.warning("Request canceled by user")
        {:halt, {acc, ref, task}}
    end
  end

  @double_eol ~r/(\r?\n|\r){2}/

  @doc false
  defp tokenize_data(evt_data, acc) do
    all_data = acc <> evt_data

    if Regex.match?(@double_eol, evt_data) do
      {remaining, token_chunks} = all_data |> String.split(@double_eol) |> List.pop_at(-1)

      tokens =
        token_chunks
        |> Enum.map(&extract_token/1)
        |> Enum.filter(fn
          %{data: "[DONE]"} -> false
          %{data: _} -> true
          # we can pass other events through but the clients will need to be rewritten
          _ -> false
        end)
        |> Enum.map(fn %{data: data} -> %{data: Jason.decode!(data)} end)

      {tokens, remaining}
    else
      {[], all_data}
    end
  end

  defp extract_token(line) do
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
