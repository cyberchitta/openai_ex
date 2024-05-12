defmodule OpenaiEx.Beta.VectorStores do
  @moduledoc """
  This module provides an implementation of the OpenAI vector_stores API. The API reference can be found at https://platform.openai.com/docs/api-reference/vector-stores.
  """

  @api_fields [
    :file_ids,
    :name,
    :expires_after,
    :metadata
  ]

  defp ep_url(vector_store_id \\ nil) do
    "/vector_stores" <>
      if(is_nil(vector_store_id), do: "", else: "/#{vector_store_id}")
  end

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{}) do
    args |> Map.take(@api_fields)
  end

  def list(openai = %OpenaiEx{}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(ep_url())
  end

  def create(openai = %OpenaiEx{}, params \\ %{}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.post(ep_url(), json: params |> Map.take(@api_fields))
  end

  def retrieve(openai = %OpenaiEx{}, vector_store_id) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(ep_url(vector_store_id))
  end

  def update(openai = %OpenaiEx{}, vector_store_id, params \\ %{}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.post(ep_url(vector_store_id),
      json: params |> Map.take([:name, :expires_after, :metadata])
    )
  end

  def delete(openai = %OpenaiEx{}, vector_store_id) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.delete(ep_url(vector_store_id))
  end
end
