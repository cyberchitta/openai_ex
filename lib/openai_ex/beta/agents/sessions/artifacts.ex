defmodule OpenaiEx.Beta.Agents.Sessions.Artifacts do
  @moduledoc """
  This module provides an implementation of the OpenAI agent session artifacts API (beta). The API reference can be found at https://developers.openai.com/api/reference/agents/sessions/artifacts.
  """
  alias OpenaiEx.Http

  defp ep_url(session_id, artifact_id \\ nil) do
    "/agents/sessions/#{session_id}/artifacts" <> if(is_nil(artifact_id), do: "", else: "/#{artifact_id}")
  end

  def retrieve!(openai = %OpenaiEx{}, session_id, artifact_id) do
    openai |> retrieve(session_id, artifact_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, session_id, artifact_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(session_id, artifact_id))
  end

  def list!(openai = %OpenaiEx{}, session_id, params \\ %{}) do
    openai |> list(session_id, params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, session_id, params \\ %{}) do
    openai
    |> OpenaiEx.with_agents_beta()
    |> Http.get(ep_url(session_id), params |> Map.take([:after, :limit, :order, :environment_id]))
  end

  def delete!(openai = %OpenaiEx{}, session_id, artifact_id) do
    openai |> delete(session_id, artifact_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, session_id, artifact_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.delete(ep_url(session_id, artifact_id))
  end

  def content!(openai = %OpenaiEx{}, session_id, artifact_id) do
    openai |> content(session_id, artifact_id) |> Http.bang_it!()
  end

  def content(openai = %OpenaiEx{}, session_id, artifact_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get_no_decode(ep_url(session_id, artifact_id) <> "/content")
  end
end
