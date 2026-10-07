defmodule OpenaiEx.Beta.Agents.Sessions.Events do
  @moduledoc """
  This module provides an implementation of the OpenAI agent session events API (beta). The API reference can be found at https://developers.openai.com/api/reference/agents/sessions/events.
  """
  alias OpenaiEx.Http

  defp ep_url(session_id) do
    "/agents/sessions/#{session_id}/events"
  end

  @doc """
  Sends events to a session. Pass `idempotency_key:` in `params` to have it sent as the `Idempotency-Key` header.
  """
  def create!(openai = %OpenaiEx{}, session_id, events, params \\ %{}) do
    openai |> create(session_id, events, params) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, session_id, events, params \\ %{}) do
    openai
    |> OpenaiEx.with_agents_beta()
    |> with_idempotency_key(params[:idempotency_key])
    |> Http.post(ep_url(session_id), json: %{events: events})
  end

  defp with_idempotency_key(openai, nil), do: openai

  defp with_idempotency_key(openai, key),
    do: openai |> OpenaiEx.with_additional_headers(%{"Idempotency-Key" => key})

  @doc """
  Streams a session's events.
  """
  def stream!(openai = %OpenaiEx{}, session_id) do
    openai |> stream(session_id) |> Http.bang_it!()
  end

  def stream(openai = %OpenaiEx{}, session_id) do
    openai
    |> OpenaiEx.with_agents_beta()
    |> OpenaiEx.with_additional_headers(%{"Accept" => "text/event-stream"})
    |> OpenaiEx.HttpSse.get(ep_url(session_id))
  end
end
