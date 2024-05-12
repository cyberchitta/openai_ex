defmodule OpenaiEx.Beta.VectorStores.File.Batches do
  @moduledoc """
  This module provides an implementation of the OpenAI vector_store file batches API. The API reference can be found at https://platform.openai.com/docs/api-reference/vector-stores-file-batches.
  """

  defp ep_url(vector_store_id, batch_id \\ nil, action \\ nil) do
    "/vector_stores" <>
      if(is_nil(vector_store_id), do: "", else: "/#{vector_store_id}") <>
      "/file_batches" <>
      if(is_nil(batch_id), do: "", else: "/#{batch_id}") <>
      if(is_nil(action), do: "", else: "/#{action}")
  end

  def list(openai = %OpenaiEx{}, vector_store_id, batch_id, params \\ %{}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(
      ep_url(vector_store_id, batch_id, "files"),
      params |> Map.take([:filter | OpenaiEx.list_query_fields()])
    )
  end

  def create(openai = %OpenaiEx{}, vector_store_id, file_ids) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.post(ep_url(vector_store_id), json: %{file_ids: file_ids})
  end

  def retrieve(openai = %OpenaiEx{}, vector_store_id, batch_id) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(ep_url(vector_store_id, batch_id))
  end

  def cancel(openai = %OpenaiEx{}, vector_store_id, batch_id) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.post(ep_url(vector_store_id, batch_id, "cancel"))
  end
end
