defmodule OpenaiEx.Containers do
  @moduledoc """
  This module provides an implementation of the OpenAI Containers API. The API reference can be found at https://platform.openai.com/docs/api-reference/containers.
  """

  alias OpenaiEx.Http

  @api_fields [
    :name,
    :expires_after,
    :file_ids,
    :container_id
  ]

  defp ep_url(container_id \\ nil) do
    "/containers" <>
      if(is_nil(container_id), do: "", else: "/#{container_id}")
  end

  @doc """
  Creates a new container request with the given arguments.

  ## Examples

      iex> OpenaiEx.Containers.new(name: "My Container")
      %{name: "My Container"}

      iex> OpenaiEx.Containers.new(name: "Test Container", expires_after: %{anchor: "last_active_at", minutes: 30})
      %{name: "Test Container", expires_after: %{anchor: "last_active_at", minutes: 30}}

      iex> OpenaiEx.Containers.new(name: "File Container", file_ids: ["file-123", "file-456"])
      %{name: "File Container", file_ids: ["file-123", "file-456"]}
  """
  def new(args) when is_list(args) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args) when is_map(args) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Lists all containers that belong to the user's organization.

  See https://platform.openai.com/docs/api-reference/containers/listContainers
  """
  def list!(openai = %OpenaiEx{}, params \\ %{}) do
    openai |> list(params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, params \\ %{}) do
    query_params = params |> Map.take(OpenaiEx.list_query_fields())
    openai |> Http.get(ep_url(), query_params)
  end

  @doc """
  Creates a new container.

  See https://platform.openai.com/docs/api-reference/containers/createContainers
  """
  def create!(openai = %OpenaiEx{}, request) do
    openai |> create(request) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, request) do
    openai |> Http.post(ep_url(), json: request)
  end

  @doc """
  Retrieves a specific container by ID.

  See https://platform.openai.com/docs/api-reference/containers/retrieveContainer
  """
  def retrieve!(openai = %OpenaiEx{}, container_id) do
    openai |> retrieve(container_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, container_id) do
    openai |> Http.get(ep_url(container_id))
  end

  @doc """
  Deletes a container.

  See https://platform.openai.com/docs/api-reference/containers/deleteContainer
  """
  def delete!(openai = %OpenaiEx{}, container_id) do
    openai |> delete(container_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, container_id) do
    openai |> Http.delete(ep_url(container_id))
  end
end
