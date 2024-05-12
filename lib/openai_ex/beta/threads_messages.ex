defmodule OpenaiEx.Beta.Threads.Messages do
  @moduledoc """
  This module provides an implementation of the OpenAI messages API. The API
  reference can be found at https://platform.openai.com/docs/api-reference/messages.
  """
  @api_fields [
    :role,
    :content,
    :attachments,
    :metadata
  ]

  defp ep_url(thread_id, message_id \\ nil) do
    "/threads/#{thread_id}/messages" <> if is_nil(message_id), do: "", else: "/#{message_id}"
  end

  @doc """
  Creates a new message request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the message request.

  ## Returns

  A map containing the fields of the message request.
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{thread_id: _, message_id: _}) do
    args
    |> Map.take([:thread_id | [:message_id | @api_fields]])
  end

  @doc """
  Calls the message create endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `params`: A map containing the fields of the message create request.

  ## Returns

  A map containing the fields of the created message object.

  https://platform.openai.com/docs/api-reference/messages/createMessage
  """
  def create(
        openai = %OpenaiEx{},
        thread_id,
        params = %{role: _role, content: _content}
      ) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.post(ep_url(thread_id), json: params |> Map.take(@api_fields))
  end

  @doc """
  Calls the message retrieve endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `params`: A map containing the fields of the message retrieve request.

  ## Returns

  A map containing the fields of the specificied message object.

  https://platform.openai.com/docs/api-reference/messages/getMessage
  """
  def retrieve(openai = %OpenaiEx{}, %{thread_id: thread_id, message_id: message_id}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(ep_url(thread_id, message_id))
  end

  @doc """
  Calls the message update endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `params`: A map containing the fields of the message update request.

  ## Returns

  A map containing the fields of the message update response.

  https://platform.openai.com/docs/api-reference/messages/modifyMessage
  """
  def update(
        openai = %OpenaiEx{},
        %{thread_id: thread_id, message_id: message_id, metadata: metadata}
      ) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.post(ep_url(thread_id, message_id), json: %{metadata: metadata})
  end

  def delete(openai = %OpenaiEx{}, thread_id, message_id) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.delete(ep_url(thread_id, message_id))
  end

  @doc """
  Lists the messages that belong to the specified thread.

  https://platform.openai.com/docs/api-reference/messages/listMessages
  """

  def new_list(args = [_ | _]) do
    args |> Enum.into(%{}) |> new_list()
  end

  def new_list(args = %{thread_id: _thread_id}) do
    args |> Map.take([:thread_id | OpenaiEx.list_query_fields()])
  end

  def list(openai = %OpenaiEx{}, thread_id, params = %{} \\ %{}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(
      ep_url(thread_id),
      params |> Map.take([:run_id | OpenaiEx.list_query_fields()])
    )
  end
end
