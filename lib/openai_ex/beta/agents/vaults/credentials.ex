defmodule OpenaiEx.Beta.Agents.Vaults.Credentials do
  @moduledoc """
  This module provides an implementation of the OpenAI agent vault credentials API (beta). The API reference can be found at https://developers.openai.com/api/reference/agents/vaults/credentials.
  """
  alias OpenaiEx.Http

  @create_fields [
    :auth,
    :name,
    :metadata
  ]

  @update_fields [
    :auth,
    :metadata
  ]

  defp ep_url(vault_id, credential_id \\ nil) do
    "/vaults/#{vault_id}/credentials" <> if(is_nil(credential_id), do: "", else: "/#{credential_id}")
  end

  def create!(openai = %OpenaiEx{}, vault_id, params) do
    openai |> create(vault_id, params) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, vault_id, params) do
    openai |> OpenaiEx.with_agents_beta() |> Http.post(ep_url(vault_id), json: params |> Map.take(@create_fields))
  end

  def retrieve!(openai = %OpenaiEx{}, vault_id, credential_id) do
    openai |> retrieve(vault_id, credential_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, vault_id, credential_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(vault_id, credential_id))
  end

  def update!(openai = %OpenaiEx{}, vault_id, credential_id, params) do
    openai |> update(vault_id, credential_id, params) |> Http.bang_it!()
  end

  def update(openai = %OpenaiEx{}, vault_id, credential_id, params) do
    openai
    |> OpenaiEx.with_agents_beta()
    |> Http.post(ep_url(vault_id, credential_id), json: params |> Map.take(@update_fields))
  end

  def list!(openai = %OpenaiEx{}, vault_id, params \\ %{}) do
    openai |> list(vault_id, params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, vault_id, params \\ %{}) do
    openai
    |> OpenaiEx.with_agents_beta()
    |> Http.get(ep_url(vault_id), params |> Map.take([:after, :limit, :order, :status]))
  end

  def delete!(openai = %OpenaiEx{}, vault_id, credential_id) do
    openai |> delete(vault_id, credential_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, vault_id, credential_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.delete(ep_url(vault_id, credential_id))
  end
end
