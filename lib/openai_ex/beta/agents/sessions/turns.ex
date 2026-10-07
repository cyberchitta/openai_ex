defmodule OpenaiEx.Beta.Agents.Sessions.Turns do
  @moduledoc """
  This module provides an implementation of the OpenAI agent session turns API (beta). The API reference can be found at https://developers.openai.com/api/reference/agents/sessions/turns.
  """
  alias OpenaiEx.Http

  defp ep_url(session_id, turn_id \\ nil) do
    "/agents/sessions/#{session_id}/turns" <> if(is_nil(turn_id), do: "", else: "/#{turn_id}")
  end

  def retrieve!(openai = %OpenaiEx{}, session_id, turn_id) do
    openai |> retrieve(session_id, turn_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, session_id, turn_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(session_id, turn_id))
  end

  def list!(openai = %OpenaiEx{}, session_id, params \\ %{}) do
    openai |> list(session_id, params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, session_id, params \\ %{}) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(session_id), params |> Map.take([:after, :limit, :order]))
  end
end
