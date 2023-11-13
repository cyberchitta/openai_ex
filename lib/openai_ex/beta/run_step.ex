defmodule OpenaiEx.Beta.Run.Step do
  @moduledoc false
  defp ep_url(thread_id, run_id, step_id \\ nil) do
    "/threads/#{thread_id}/runs/#{run_id}/steps" <>
      if is_nil(step_id), do: "", else: "/#{step_id}"
  end

  def retrieve(openai = %OpenaiEx{}, %{thread_id: thread_id, run_id: run_id, step_id: step_id}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(ep_url(thread_id, run_id, step_id))
  end

  def list(openai = %OpenaiEx{}, params = %{thread_id: thread_id, run_id: run_id}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(
      ep_url(thread_id, run_id),
      params |> Map.take(OpenaiEx.list_query_fields())
    )
  end
end
