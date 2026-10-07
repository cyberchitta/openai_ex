defmodule OpenaiEx.Beta.Agents do
  @moduledoc """
  This module provides an implementation of the OpenAI agents API (beta). The API reference can be found at https://developers.openai.com/api/reference/agents.
  """
  alias OpenaiEx.Http

  @create_fields [
    :model,
    :instructions,
    :metadata,
    :multi_agent,
    :name,
    :reasoning,
    :service_tier,
    :text,
    :tools
  ]

  @update_fields [
    :instructions,
    :metadata,
    :model,
    :multi_agent,
    :name,
    :reasoning,
    :service_tier,
    :text,
    :tools
  ]

  @doc """
  Creates a new agent request with the given arguments.

  Example usage:

      iex> OpenaiEx.Beta.Agents.new(model: "gpt-6.1-sol", name: "Researcher", instructions: "Be brief.")
      %{instructions: "Be brief.", model: "gpt-6.1-sol", name: "Researcher"}
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{model: _}) do
    args |> Map.take(@create_fields)
  end

  defp ep_url(agent_id \\ nil) do
    "/agents" <> if(is_nil(agent_id), do: "", else: "/#{agent_id}")
  end

  def create!(openai = %OpenaiEx{}, params) do
    openai |> create(params) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, params) do
    openai |> OpenaiEx.with_agents_beta() |> Http.post(ep_url(), json: params |> Map.take(@create_fields))
  end

  def retrieve!(openai = %OpenaiEx{}, agent_id) do
    openai |> retrieve(agent_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, agent_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(agent_id))
  end

  def update!(openai = %OpenaiEx{}, agent_id, params) do
    openai |> update(agent_id, params) |> Http.bang_it!()
  end

  def update(openai = %OpenaiEx{}, agent_id, params) do
    openai |> OpenaiEx.with_agents_beta() |> Http.post(ep_url(agent_id), json: params |> Map.take(@update_fields))
  end

  def list!(openai = %OpenaiEx{}, params \\ %{}) do
    openai |> list(params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, params \\ %{}) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(), params |> Map.take([:after, :limit, :order]))
  end

  def delete!(openai = %OpenaiEx{}, agent_id) do
    openai |> delete(agent_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, agent_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.delete(ep_url(agent_id))
  end
end
