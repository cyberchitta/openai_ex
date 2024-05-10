defmodule OpenaiEx.Beta.VectorStores do
  @moduledoc false

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

  def new(args = %{vector_store_id: _}) do
    args |> Map.take(@api_fields)
  end

  def list(openai = %OpenaiEx{}) do
    openai |> OpenaiEx.Http.get(ep_url())
  end

  def create(openai = %OpenaiEx{}, params \\ %{}) do
    openai |> OpenaiEx.Http.post(ep_url(), json: params |> Map.take(@api_fields))
  end

  def delete(openai = %OpenaiEx{}, vector_store_id) do
    openai |> OpenaiEx.Http.delete(ep_url(vector_store_id))
  end

  def retrieve(openai = %OpenaiEx{}, vector_store_id) do
    openai |> OpenaiEx.Http.get(ep_url(vector_store_id))
  end
end
