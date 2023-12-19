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
    combined_data = acc <> evt_data

    if contains_terminator?(combined_data) do
      {remaining, token_chunks} = split_on_terminators(combined_data)

      tokens =
        token_chunks
        |> Enum.map(&extract_token/1)
        |> Enum.filter(fn %{data: data} -> data != "[DONE]" end)
        |> Enum.map(fn %{data: data} -> %{data: Jason.decode!(data)} end)

      {tokens, remaining}
    else
      {[], combined_data}
    end
  end

  defp contains_terminator?(data) do
    String.contains?(data, "\n\n") or String.contains?(data, "\r\n\r\n")
  end

  defp split_on_terminators(data) do
    data
    |> String.replace("\r\n\r\n", "\n\n")
    |> String.split("\n\n")
    |> List.pop_at(-1)
  end

  # and here just added a default handler for when it doesn't come in as `data:`
  defp extract_token(line) do
    [field | rest] = String.split(line, ": ", parts: 2)

    case field do
      "data" -> %{data: Enum.join(rest, "") |> String.replace_prefix(" ", "")}
      _ -> %{data: ""}
    end
  end
end
