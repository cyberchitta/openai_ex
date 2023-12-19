defmodule OpenaiEx.HttpSse do
  @moduledoc false
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
        on_chunk = fn chunk, _acc -> send(me, {:chunk, chunk, ref}) end
        request |> Finch.stream(OpenaiEx.Finch, nil, on_chunk)
        send(me, {:done, ref})
      end)

    _status = receive(do: ({:chunk, {:status, status}, ^ref} -> status))
    _headers = receive(do: ({:chunk, {:headers, headers}, ^ref} -> headers))

    Stream.resource(fn -> {"", ref, task} end, &next_sse/1, fn {_data, _ref, task} ->
      Task.shutdown(task)
    end)
  end

  @doc false
  defp next_sse({acc, ref, task}) do
    receive do
      {:chunk, {:data, evt_data}, ^ref} ->
        {tokens, next_acc} = tokenize_data(evt_data, acc)
        {[tokens], {next_acc, ref, task}}

      {:done, ^ref} ->
        if acc != "" do
          Logger.warning(inspect(Jason.decode!(acc)))
        end

        {:halt, {acc, ref, task}}
    end
  end

  @doc false
  defp tokenize_data(evt_data, acc) do
    all_data = acc <> evt_data

    # finds 2 (repeated) EOL characters
    if Regex.match?(~r/(\r?\n|\r){2}/, evt_data) do
      {remaining, token_chunks} = all_data |> String.split(~r/(\r?\n|\r){2}/) |> List.pop_at(-1)

      tokens =
        token_chunks
        |> Enum.map(&extract_token/1)
        |> Enum.filter(fn
          %{data: "[DONE]"} -> false
          %{data: _} -> true
          _ -> false # we can pass other events through but the clients will need to be rewritten
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
      _ -> nil # comment
    end
  end
end
