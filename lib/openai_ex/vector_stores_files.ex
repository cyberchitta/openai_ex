defmodule OpenaiEx.VectorStores.Files do
  @moduledoc """
  This module provides an implementation of the OpenAI vector_store files API. The API reference can be found at https://platform.openai.com/docs/api-reference/vector-stores-files.
  """
  alias OpenaiEx.Http

  defp ep_url(vector_store_id, file_id \\ nil) do
    "/vector_stores" <>
      if(is_nil(vector_store_id), do: "", else: "/#{vector_store_id}") <>
      "/files" <>
      if(is_nil(file_id), do: "", else: "/#{file_id}")
  end

  def list!(openai = %OpenaiEx{}, vector_store_id, params \\ %{}) do
    openai |> list(vector_store_id, params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, vector_store_id, params \\ %{}) do
    qry_params = params |> Map.take([:filter | OpenaiEx.list_query_fields()])
    openai |> Http.get(ep_url(vector_store_id), qry_params)
  end

  def create!(openai = %OpenaiEx{}, vector_store_id, file_id, params \\ %{}) do
    openai |> create(vector_store_id, file_id, params) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, vector_store_id, file_id, params \\ %{}) do
    json =
      %{file_id: file_id}
      |> Map.merge(params |> Map.take([:attributes]))

    openai |> Http.post(ep_url(vector_store_id), json: json)
  end

  def retrieve!(openai = %OpenaiEx{}, vector_store_id, file_id) do
    openai |> retrieve(vector_store_id, file_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, vector_store_id, file_id) do
    openai |> Http.get(ep_url(vector_store_id, file_id))
  end

  def delete!(openai = %OpenaiEx{}, vector_store_id, file_id) do
    openai |> delete(vector_store_id, file_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, vector_store_id, file_id) do
    openai |> Http.delete(ep_url(vector_store_id, file_id))
  end
end
