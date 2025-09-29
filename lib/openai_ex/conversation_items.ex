defmodule OpenaiEx.ConversationItems do
  @moduledoc """
  This module provides an implementation of the OpenAI Conversation Items API. The API reference can be found at https://platform.openai.com/docs/api-reference/conversations/items.
  """

  alias OpenaiEx.Http

  @api_fields [
    :items
  ]

  defp ep_url(conversation_id, item_id \\ nil) do
    base = "/conversations/#{conversation_id}/items"

    if is_nil(item_id), do: base, else: "#{base}/#{item_id}"
  end

  @doc """
  Creates a new conversation items request with the given arguments.

  ## Examples

      iex> OpenaiEx.ConversationItems.new(items: [%{type: "message", role: "user", content: [%{type: "input_text", text: "Hello"}]}])
      %{items: [%{type: "message", role: "user", content: [%{type: "input_text", text: "Hello"}]}]}
  """
  def new(args) when is_list(args) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args) when is_map(args) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Creates conversation items (one or more messages).

  See https://platform.openai.com/docs/api-reference/conversations/createItem
  """
  def create!(openai = %OpenaiEx{}, conversation_id, request) do
    openai |> create(conversation_id, request) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, conversation_id, request) do
    openai |> Http.post(ep_url(conversation_id), json: request)
  end

  @doc """
  Retrieves a specific conversation item by ID.

  See https://platform.openai.com/docs/api-reference/conversations/retrieveItem
  """
  def retrieve!(openai = %OpenaiEx{}, conversation_id, item_id) do
    openai |> retrieve(conversation_id, item_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, conversation_id, item_id) do
    openai |> Http.get(ep_url(conversation_id, item_id))
  end

  @doc """
  Lists all items in a conversation.

  See https://platform.openai.com/docs/api-reference/conversations/listItems
  """
  def list!(openai = %OpenaiEx{}, conversation_id, params \\ %{}) do
    openai |> list(conversation_id, params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, conversation_id, params \\ %{}) do
    query_params = params |> Map.take(OpenaiEx.list_query_fields())
    openai |> Http.get(ep_url(conversation_id), query_params)
  end

  @doc """
  Deletes a conversation item.

  See https://platform.openai.com/docs/api-reference/conversations/deleteItem
  """
  def delete!(openai = %OpenaiEx{}, conversation_id, item_id) do
    openai |> delete(conversation_id, item_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, conversation_id, item_id) do
    openai |> Http.delete(ep_url(conversation_id, item_id))
  end
end
