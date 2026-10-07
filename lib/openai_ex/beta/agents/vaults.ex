defmodule OpenaiEx.Beta.Agents.Vaults do
  @moduledoc """
  This module provides an implementation of the OpenAI agent vaults API (beta). The API reference can be found at https://developers.openai.com/api/reference/agents/vaults.
  """
  alias OpenaiEx.Http

  @create_fields [
    :metadata,
    :name
  ]

  defp ep_url(vault_id \\ nil) do
    "/vaults" <> if(is_nil(vault_id), do: "", else: "/#{vault_id}")
  end

  def create!(openai = %OpenaiEx{}, params) do
    openai |> create(params) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, params) do
    openai |> OpenaiEx.with_agents_beta() |> Http.post(ep_url(), json: params |> Map.take(@create_fields))
  end

  def retrieve!(openai = %OpenaiEx{}, vault_id) do
    openai |> retrieve(vault_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, vault_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(vault_id))
  end

  def list!(openai = %OpenaiEx{}, params \\ %{}) do
    openai |> list(params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, params \\ %{}) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(), params |> Map.take([:after, :limit, :order, :status]))
  end

  def delete!(openai = %OpenaiEx{}, vault_id) do
    openai |> delete(vault_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, vault_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.delete(ep_url(vault_id))
  end
end
