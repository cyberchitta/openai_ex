defmodule OpenaiEx.Beta.VectorStores.File.Batches do
  @moduledoc false

  defp ep_url(vector_store_id, batch_id \\ nil, action \\ nil) do
    "/vector_stores" <>
      if(is_nil(vector_store_id), do: "", else: "/#{vector_store_id}") <>
      "/file_batches" <>
      if(is_nil(batch_id), do: "", else: "/#{batch_id}") <>
      if(is_nil(action), do: "", else: "/#{action}")
  end

  @doc false
  def list(openai = %OpenaiEx{}, vector_store_id, batch_id, params \\ %{}) do
    openai
    |> OpenaiEx.Http.get(
      ep_url(vector_store_id, batch_id, "files"),
      params |> Map.take([:filter | OpenaiEx.list_query_fields()])
    )
  end

  @doc false
  def create(openai = %OpenaiEx{}, vector_store_id, file_ids) do
    openai |> OpenaiEx.Http.post(ep_url(vector_store_id), json: %{file_ids: file_ids})
  end

  @doc false
  def cancel(openai = %OpenaiEx{}, vector_store_id, file_id) do
    openai |> OpenaiEx.Http.post(ep_url(vector_store_id, file_id, "cancel"))
  end

  @doc false
  def retrieve(openai = %OpenaiEx{}, vector_store_id, batch_id) do
    openai |> OpenaiEx.Http.get(ep_url(vector_store_id, batch_id))
  end
end
