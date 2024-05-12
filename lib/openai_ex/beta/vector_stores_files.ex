defmodule OpenaiEx.Beta.VectorStores.Files do
  @moduledoc """
  This module provides an implementation of the OpenAI vector_store files API. The API reference can be found at https://platform.openai.com/docs/api-reference/vector-stores-files.
  """

  defp ep_url(vector_store_id, file_id \\ nil) do
    "/vector_stores" <>
      if(is_nil(vector_store_id), do: "", else: "/#{vector_store_id}") <>
      "/files" <>
      if(is_nil(file_id), do: "", else: "/#{file_id}")
  end

  def list(openai = %OpenaiEx{}, vector_store_id, params \\ %{}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(
      ep_url(vector_store_id),
      params |> Map.take([:filter | OpenaiEx.list_query_fields()])
    )
  end

  def create(openai = %OpenaiEx{}, vector_store_id, file_id) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.post(ep_url(vector_store_id), json: %{file_id: file_id})
  end

  def retrieve(openai = %OpenaiEx{}, vector_store_id, file_id) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(ep_url(vector_store_id, file_id))
  end

  def delete(openai = %OpenaiEx{}, vector_store_id, file_id) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.delete(ep_url(vector_store_id, file_id))
  end
end
