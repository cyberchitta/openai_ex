defmodule OpenaiEx.VectorStores.File.Batches do
  @moduledoc """
  This module provides an implementation of the OpenAI vector_store file batches API. The API reference can be found at https://platform.openai.com/docs/api-reference/vector-stores-file-batches.
  """
  alias OpenaiEx.Http

  defp ep_url(vector_store_id, batch_id \\ nil, action \\ nil) do
    "/vector_stores" <>
      if(is_nil(vector_store_id), do: "", else: "/#{vector_store_id}") <>
      "/file_batches" <>
      if(is_nil(batch_id), do: "", else: "/#{batch_id}") <>
      if(is_nil(action), do: "", else: "/#{action}")
  end

  def list!(openai = %OpenaiEx{}, vector_store_id, batch_id, params \\ %{}) do
    openai |> list(vector_store_id, batch_id, params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, vector_store_id, batch_id, params \\ %{}) do
    url = ep_url(vector_store_id, batch_id, "files")
    qry_params = params |> Map.take([:filter | OpenaiEx.list_query_fields()])
    openai |> Http.get(url, qry_params)
  end

  def create!(openai = %OpenaiEx{}, vector_store_id, file_ids) do
    openai |> create(vector_store_id, file_ids) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, vector_store_id, file_ids) do
    url = ep_url(vector_store_id)
    openai |> Http.post(url, json: %{file_ids: file_ids})
  end

  def retrieve!(openai = %OpenaiEx{}, vector_store_id, batch_id) do
    openai |> retrieve(vector_store_id, batch_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, vector_store_id, batch_id) do
    openai |> Http.get(ep_url(vector_store_id, batch_id))
  end

  def cancel!(openai = %OpenaiEx{}, vector_store_id, batch_id) do
    openai |> cancel(vector_store_id, batch_id) |> Http.bang_it!()
  end

  def cancel(openai = %OpenaiEx{}, vector_store_id, batch_id) do
    url = ep_url(vector_store_id, batch_id, "cancel")
    openai |> Http.post(url)
  end
end
