defmodule OpenaiEx.Beta.Agents.Environments.Templates do
  @moduledoc """
  This module provides an implementation of the OpenAI agent environment templates API (beta). The API reference can be found at https://developers.openai.com/api/reference/agents/environments/templates.
  """
  alias OpenaiEx.Http

  @create_fields [
    :capability_directories,
    :desktop,
    :env,
    :files,
    :name,
    :network,
    :packages,
    :plugins,
    :setup_commands,
    :skills
  ]

  @update_fields [
    :capability_directories,
    :desktop,
    :env,
    :files,
    :name,
    :network,
    :packages,
    :plugins,
    :setup_commands,
    :skills
  ]

  defp ep_url(environment_template_id \\ nil) do
    "/agents/environments/templates" <> if(is_nil(environment_template_id), do: "", else: "/#{environment_template_id}")
  end

  def create!(openai = %OpenaiEx{}, params) do
    openai |> create(params) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, params) do
    openai |> OpenaiEx.with_agents_beta() |> Http.post(ep_url(), json: params |> Map.take(@create_fields))
  end

  def retrieve!(openai = %OpenaiEx{}, environment_template_id) do
    openai |> retrieve(environment_template_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, environment_template_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(environment_template_id))
  end

  def update!(openai = %OpenaiEx{}, environment_template_id, params) do
    openai |> update(environment_template_id, params) |> Http.bang_it!()
  end

  def update(openai = %OpenaiEx{}, environment_template_id, params) do
    openai
    |> OpenaiEx.with_agents_beta()
    |> Http.post(ep_url(environment_template_id), json: params |> Map.take(@update_fields))
  end

  def list!(openai = %OpenaiEx{}, params \\ %{}) do
    openai |> list(params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, params \\ %{}) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(), params |> Map.take([:after, :limit, :order]))
  end

  def delete!(openai = %OpenaiEx{}, environment_template_id) do
    openai |> delete(environment_template_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, environment_template_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.delete(ep_url(environment_template_id))
  end
end
