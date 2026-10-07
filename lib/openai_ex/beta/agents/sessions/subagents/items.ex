defmodule OpenaiEx.Beta.Agents.Sessions.Subagents.Items do
  @moduledoc """
  This module provides an implementation of the OpenAI agent session subagent items API (beta). The API reference can be found at https://developers.openai.com/api/reference/agents/sessions/subagents/items.
  """
  alias OpenaiEx.Http

  defp ep_url(session_id, subagent_id) do
    "/agents/sessions/#{session_id}/subagents/#{subagent_id}/items"
  end

  def list!(openai = %OpenaiEx{}, session_id, subagent_id, params \\ %{}) do
    openai |> list(session_id, subagent_id, params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, session_id, subagent_id, params \\ %{}) do
    openai
    |> OpenaiEx.with_agents_beta()
    |> Http.get(ep_url(session_id, subagent_id), params |> Map.take([:after, :limit, :order]))
  end
end
