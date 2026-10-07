# Runs a Livebook notebook headless, the way Livebook would: one session,
# cells in order, bindings and aliases carried from cell to cell.
#
#   elixir scripts/run_notebook.exs notebooks/userguide.livemd
#
# The first elixir cell is the notebook's setup (Mix.install) and runs once.
# Cells marked force_markdown are skipped, as Livebook skips them. A cell that
# raises is retried twice (after 10s and 20s), because some API reads lag the
# write before them; a CompileError is never retried, since it means an earlier
# cell failed. Set RUNNER_SHOW=1 to print each cell's value.
#
# Notebooks read the key from LB_OPENAI_API_KEY, which Livebook derives from
# OPENAI_API_KEY. Outside Livebook, set it yourself.

[path] = System.argv()
dir = Path.dirname(Path.expand(path))
show? = System.get_env("RUNNER_SHOW") != nil

{cells, _, _, _} =
  path
  |> File.read!()
  |> String.split("\n")
  |> Enum.with_index(1)
  |> Enum.reduce({[], nil, false, nil}, fn {line, n}, {cells, cur, skip_next, sec} ->
    sec = if String.starts_with?(line, ["## ", "### "]), do: line, else: sec

    cond do
      cur == nil and String.starts_with?(line, "```elixir") ->
        {cells, {n, sec, [], skip_next}, false, sec}

      cur != nil and String.starts_with?(line, "```") ->
        {start, s, acc, skip} = cur
        src = acc |> Enum.reverse() |> Enum.join("\n")
        {if(skip, do: cells, else: [{start, s, src} | cells]), nil, false, sec}

      cur != nil ->
        {start, s, acc, skip} = cur
        {cells, {start, s, [line | acc], skip}, skip_next, sec}

      String.contains?(line, ~s("force_markdown":true)) ->
        {cells, nil, true, sec}

      String.trim(line) == "" ->
        {cells, nil, skip_next, sec}

      true ->
        {cells, nil, false, sec}
    end
  end)

[{_, _, setup} | cells] = Enum.reverse(cells)
setup |> String.replace("__DIR__", inspect(dir)) |> Code.eval_string()
IO.puts("setup ok, #{length(cells)} cells")

eval_cell = fn src, n, binding, env ->
  try do
    quoted = Code.string_to_quoted!(src, file: path, line: n + 1)
    {value, binding, env} = Code.eval_quoted_with_env(quoted, binding, env)
    if show?, do: IO.puts("L#{n} => #{inspect(value, limit: 20, printable_limit: 200)}")
    {:ok, binding, env}
  rescue
    e in CompileError -> {:fatal, Exception.format_banner(:error, e)}
    e -> {:retry, Exception.format_banner(:error, e)}
  catch
    kind, reason -> {:retry, "#{kind} #{inspect(reason)}"}
  end
end

{_, _, failures} =
  Enum.reduce(cells, {[], __ENV__, 0}, fn {n, sec, src}, {binding, env, failures} ->
    src = String.replace(src, "__DIR__", inspect(dir))
    t0 = System.monotonic_time(:millisecond)

    result =
      Enum.reduce_while([10, 20, nil], nil, fn delay, _ ->
        case eval_cell.(src, n, binding, env) do
          {:retry, msg} when delay != nil ->
            IO.puts("L#{n} retry in #{delay}s after: #{String.slice(msg, 0, 300)}")
            Process.sleep(delay * 1000)
            {:cont, nil}

          other ->
            {:halt, other}
        end
      end)

    ms = System.monotonic_time(:millisecond) - t0

    case result do
      {:ok, binding, env} ->
        IO.puts("L#{n} [#{sec}] #{ms}ms ok")
        {binding, env, failures}

      {_, msg} ->
        IO.puts("L#{n} [#{sec}] #{ms}ms FAIL #{String.slice(msg, 0, 300)}")
        {binding, env, failures + 1}
    end
  end)

IO.puts("DONE failures=#{failures}")
if failures > 0, do: System.halt(1)
