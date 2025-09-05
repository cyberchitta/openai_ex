defmodule OpenaiEx.VectorStores do
  @moduledoc """
  This module provides an implementation of the OpenAI vector_stores API. The API reference can be found at https://platform.openai.com/docs/api-reference/vector-stores.
  """
  alias OpenaiEx.Http

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

  @doc """
  Creates a new vector store request

  Example usage:

      iex> _request = OpenaiEx.VectorStores.new(name: "My Vector Store", file_ids: ["file-abc123"])
      %{name: "My Vector Store", file_ids: ["file-abc123"]}

      iex> _request = OpenaiEx.VectorStores.new(%{name: "My Vector Store", metadata: %{"version" => "1.0"}})
      %{name: "My Vector Store", metadata: %{"version" => "1.0"}}
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{}) do
    args |> Map.take(@api_fields)
  end

  def list!(openai = %OpenaiEx{}) do
    openai |> list() |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}) do
    openai |> Http.get(ep_url())
  end

  def create!(openai = %OpenaiEx{}, params \\ %{}) do
    openai |> create(params) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, params \\ %{}) do
    json = params |> Map.take(@api_fields)
    openai |> Http.post(ep_url(), json: json)
  end

  def retrieve!(openai = %OpenaiEx{}, vector_store_id) do
    openai |> retrieve(vector_store_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, vector_store_id) do
    openai |> Http.get(ep_url(vector_store_id))
  end

  def update!(openai = %OpenaiEx{}, vector_store_id, params \\ %{}) do
    openai |> update(vector_store_id, params) |> Http.bang_it!()
  end

  def update(openai = %OpenaiEx{}, vector_store_id, params \\ %{}) do
    json = params |> Map.take([:name, :expires_after, :metadata])
    openai |> Http.post(ep_url(vector_store_id), json: json)
  end

  def delete!(openai = %OpenaiEx{}, vector_store_id) do
    openai |> delete(vector_store_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, vector_store_id) do
    openai |> Http.delete(ep_url(vector_store_id))
  end
end
