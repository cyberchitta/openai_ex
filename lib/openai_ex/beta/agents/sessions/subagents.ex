defmodule OpenaiEx.Beta.Agents.Sessions.Subagents do
  @moduledoc """
  This module provides an implementation of the OpenAI agent session subagents API (beta). The API reference can be found at https://developers.openai.com/api/reference/agents/sessions/subagents.
  """
  alias OpenaiEx.Http

  defp ep_url(session_id, subagent_id \\ nil) do
    "/agents/sessions/#{session_id}/subagents" <> if(is_nil(subagent_id), do: "", else: "/#{subagent_id}")
  end

  def retrieve!(openai = %OpenaiEx{}, session_id, subagent_id) do
    openai |> retrieve(session_id, subagent_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, session_id, subagent_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(session_id, subagent_id))
  end

  def list!(openai = %OpenaiEx{}, session_id, params \\ %{}) do
    openai |> list(session_id, params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, session_id, params \\ %{}) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(session_id), params |> Map.take([:after, :limit, :order]))
  end
end
