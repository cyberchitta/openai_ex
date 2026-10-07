defmodule OpenaiEx.Beta.Agents.Environments.Files do
  @moduledoc """
  This module provides an implementation of the OpenAI agent environment files API (beta). The API reference can be found at https://developers.openai.com/api/reference/agents/environments/files.
  """
  alias OpenaiEx.Http

  @create_fields [
    :type,
    :path,
    :file_id,
    :data
  ]

  defp ep_url(environment_id) do
    "/agents/environments/#{environment_id}/files"
  end

  def create!(openai = %OpenaiEx{}, environment_id, params) do
    openai |> create(environment_id, params) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, environment_id, params) do
    openai |> OpenaiEx.with_agents_beta() |> Http.post(ep_url(environment_id), json: params |> Map.take(@create_fields))
  end

  def list!(openai = %OpenaiEx{}, environment_id, params \\ %{}) do
    openai |> list(environment_id, params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, environment_id, params \\ %{}) do
    openai
    |> OpenaiEx.with_agents_beta()
    |> Http.get(ep_url(environment_id), params |> Map.take([:limit, :order, :page, :path]))
  end
end
