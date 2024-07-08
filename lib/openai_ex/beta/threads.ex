defmodule OpenaiEx.Beta.Threads do
  @moduledoc """
  This module provides an implementation of the OpenAI threads API. The API reference can be found at https://platform.openai.com/docs/api-reference/threads.
  """
  @api_fields [
    :messages,
    :tool_resources,
    :metadata
  ]

  defp ep_url(thread_id \\ nil) do
    "/threads" <> if is_nil(thread_id), do: "", else: "/#{thread_id}"
  end

  @doc """
  Creates a new threads request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the threads request.

  ## Returns

  A map containing the fields of the threads request.
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{}) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Calls the thread create endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `params`: A map containing the fields of the thread create request.

  ## Returns

  A map containing the fields of the created thread object.

  https://platform.openai.com/docs/api-reference/threads/createThread
  """
  def create(openai = %OpenaiEx{}, params = %{} \\ %{}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.post(ep_url(), json: params |> Map.take(@api_fields))
  end

  @doc """
  Calls the thread retrieve endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `thread_id`: The ID of the thread to retrieve.

  ## Returns

  A map containing the fields of the specified thread object.

  https://platform.openai.com/docs/api-reference/threads/getThread
  """
  def retrieve(openai = %OpenaiEx{}, thread_id) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(ep_url(thread_id))
  end

  @doc """
  Calls the thread update endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `thread_id`: The ID of the thread to update.
  - `params`: The thread update request, as a map with keys corresponding to the API fields.

  ## Returns

  A map containing the fields of the modified thread.

  https://platform.openai.com/docs/api-reference/threads/modifyThread
  """
  def update(openai = %OpenaiEx{}, thread_id, params = %{metadata: _metadata}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.post(ep_url(thread_id), json: params |> Map.take([:thread_id, :metadata]))
  end

  @doc """
  Calls the thread delete endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `params`: A map containing the fields of the thread delete request.

  ## Returns

  A map containing the fields of the thread delete response.

  https://platform.openai.com/docs/api-reference/threads/deleteThread
  """
  def delete(openai = %OpenaiEx{}, thread_id) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.delete(ep_url(thread_id))
  end

  # Not (yet) part of the documented API, but the endpoint exists.
  @doc false
  def list(openai = %OpenaiEx{}, params = %{} \\ %{}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(ep_url(), params |> Map.take(OpenaiEx.list_query_fields()))
  end
end
