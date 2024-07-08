defmodule OpenaiEx.Beta.Threads.Runs.Steps do
  @moduledoc """
  This module provides an implementation of the OpenAI run steps API. The API reference can be found at https://platform.openai.com/docs/api-reference/run-steps.
  """
  alias OpenaiEx.Http

  defp ep_url(thread_id, run_id, step_id \\ nil) do
    "/threads/#{thread_id}/runs/#{run_id}/steps" <>
      if is_nil(step_id), do: "", else: "/#{step_id}"
  end

  def retrieve!(openai = %OpenaiEx{}, params = %{thread_id: _, run_id: _, step_id: _}) do
    openai |> retrieve(params) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, %{thread_id: thread_id, run_id: run_id, step_id: step_id}) do
    openai |> OpenaiEx.with_assistants_beta() |> Http.get(ep_url(thread_id, run_id, step_id))
  end

  def list!(openai = %OpenaiEx{}, params = %{thread_id: _, run_id: _}) do
    openai |> list(params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, params = %{thread_id: thread_id, run_id: run_id}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> Http.get(ep_url(thread_id, run_id), params |> Map.take(OpenaiEx.list_query_fields()))
  end
end
