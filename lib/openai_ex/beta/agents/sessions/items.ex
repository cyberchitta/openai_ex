defmodule OpenaiEx.Beta.Agents.Sessions.Items do
  @moduledoc """
  This module provides an implementation of the OpenAI agent session items API (beta). The API reference can be found at https://developers.openai.com/api/reference/agents/sessions/items.
  """
  alias OpenaiEx.Http

  defp ep_url(session_id) do
    "/agents/sessions/#{session_id}/items"
  end

  def list!(openai = %OpenaiEx{}, session_id, params \\ %{}) do
    openai |> list(session_id, params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, session_id, params \\ %{}) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(session_id), params |> Map.take([:after, :limit, :order]))
  end
end
