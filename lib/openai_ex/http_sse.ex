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
        {:halt, {acc, ref, task}}
    end
  end

  @doc false
  defp tokenize_data(evt_data, acc) do
    cond do
      String.contains?(evt_data, "\n\n") ->
        evt_chunks = String.split(acc <> evt_data, "\n\n")
        {rem, token_chunks} = List.pop_at(evt_chunks, -1)

        tokens =
          token_chunks
          |> Enum.map(fn chunk -> extract_token(chunk) end)
          |> Enum.filter(fn %{data: data} -> data != "[DONE]" end)
          |> Enum.map(fn %{data: data} -> %{data: Jason.decode!(data)} end)

        {tokens, rem}

      true ->
        {[], acc <> evt_data}
    end
  end

  @doc false
  defp extract_token(line) do
    [field | rest] = String.split(line, ": ", parts: 2)

    case field do
      "data" -> %{data: Enum.join(rest, "") |> String.replace_prefix(" ", "")}
    end
  end
end
