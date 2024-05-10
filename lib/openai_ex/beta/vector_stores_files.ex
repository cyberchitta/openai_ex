defmodule OpenaiEx.Beta.VectorStores.Files do
  @moduledoc false

  defp ep_url(vector_store_id, file_id \\ nil) do
    "/vector_stores" <>
      if(is_nil(vector_store_id), do: "", else: "/#{vector_store_id}") <>
      "/files" <>
      if(is_nil(file_id), do: "", else: "/#{file_id}")
  end

  @doc false
  def list(openai = %OpenaiEx{}, vector_store_id, params \\ %{}) do
    openai
    |> OpenaiEx.Http.get(
      ep_url(vector_store_id),
      params |> Map.take([:filter | OpenaiEx.list_query_fields()])
    )
  end

  @doc false
  def create(openai = %OpenaiEx{}, vector_store_id, file_id) do
    openai |> OpenaiEx.Http.post(ep_url(vector_store_id, file_id))
  end

  @doc false
  def delete(openai = %OpenaiEx{}, vector_store_id, file_id) do
    openai |> OpenaiEx.Http.delete(ep_url(vector_store_id, file_id))
  end

  @doc false
  def retrieve(openai = %OpenaiEx{}, vector_store_id, file_id) do
    openai |> OpenaiEx.Http.get(ep_url(vector_store_id, file_id))
  end
end
