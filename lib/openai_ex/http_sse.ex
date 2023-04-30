defmodule OpenaiEx.HttpSse do
  @moduledoc false

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

    Stream.resource(fn -> {ref, task} end, &next_sse/1, fn {_ref, task} ->
      Task.shutdown(task)
    end)
  end

  @doc false
  defp next_sse({ref, task}) do
    receive do
      {:chunk, {:data, value}, ^ref} -> {[value |> to_sse_data()], {ref, task}}
      {:done, ^ref} -> {:halt, {ref, task}}
    end
  end

  @doc false
  defp to_sse_data(value) do
    String.split(value, "\n\n", trim: true)
    |> Enum.map(fn line ->
      [field | rest] = String.split(line, ": ", parts: 2)
      value = Enum.join(rest, "") |> String.replace_prefix(" ", "")

      case field do
        "data" -> %{data: value}
      end
    end)
    |> Enum.filter(fn %{data: data} -> data != "[DONE]" end)
    |> Enum.map(fn %{data: data} -> %{data: Jason.decode!(data)} end)
  end
end
