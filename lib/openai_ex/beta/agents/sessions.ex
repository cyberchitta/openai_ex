defmodule OpenaiEx.Beta.Agents.Sessions do
  @moduledoc """
  This module provides an implementation of the OpenAI agent sessions API (beta). The API reference can be found at https://developers.openai.com/api/reference/agents/sessions.
  """
  alias OpenaiEx.Http

  @create_fields [
    :environment,
    :agent,
    :agent_id,
    :input,
    :metadata,
    :vault_ids
  ]

  @update_fields [
    :agent,
    :metadata
  ]

  @doc """
  Creates a new agent session request with the given arguments.

  Example usage:

      iex> OpenaiEx.Beta.Agents.Sessions.new(environment: %{type: "none"}, agent_id: "agent_123", input: "Hello")
      %{agent_id: "agent_123", environment: %{type: "none"}, input: "Hello"}
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{environment: _}) do
    args |> Map.take(@create_fields)
  end

  defp ep_url(session_id \\ nil) do
    "/agents/sessions" <> if(is_nil(session_id), do: "", else: "/#{session_id}")
  end

  @doc """
  Creates a new agent session. Pass `stream: true` to receive the session's events as a stream.
  """
  def create!(openai = %OpenaiEx{}, params, stream: true) do
    openai |> create(params, stream: true) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, params, stream: true) do
    json = params |> Map.take(@create_fields) |> Map.put(:stream, true)
    openai |> OpenaiEx.with_agents_beta() |> OpenaiEx.HttpSse.post(ep_url(), json: json)
  end

  def create!(openai = %OpenaiEx{}, params) do
    openai |> create(params) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, params) do
    openai |> OpenaiEx.with_agents_beta() |> Http.post(ep_url(), json: params |> Map.take(@create_fields))
  end

  def retrieve!(openai = %OpenaiEx{}, session_id) do
    openai |> retrieve(session_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, session_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(session_id))
  end

  def update!(openai = %OpenaiEx{}, session_id, params) do
    openai |> update(session_id, params) |> Http.bang_it!()
  end

  def update(openai = %OpenaiEx{}, session_id, params) do
    openai |> OpenaiEx.with_agents_beta() |> Http.post(ep_url(session_id), json: params |> Map.take(@update_fields))
  end

  def list!(openai = %OpenaiEx{}, params \\ %{}) do
    openai |> list(params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, params \\ %{}) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(), params |> Map.take([:after, :limit, :order, :agent_id]))
  end

  def delete!(openai = %OpenaiEx{}, session_id) do
    openai |> delete(session_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, session_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.delete(ep_url(session_id))
  end
end
