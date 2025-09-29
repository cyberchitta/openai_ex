defmodule OpenaiEx.Conversations do
  @moduledoc """
  This module provides an implementation of the OpenAI Conversations API. The API reference can be found at https://platform.openai.com/docs/api-reference/conversations.
  """

  alias OpenaiEx.Http

  @api_fields [
    :metadata,
    :items
  ]

  defp ep_url(conversation_id \\ nil) do
    "/conversations" <>
      if(is_nil(conversation_id), do: "", else: "/#{conversation_id}")
  end

  @doc """
  Creates a new conversation request with the given arguments.

  ## Examples

      iex> OpenaiEx.Conversations.new(metadata: %{"user_id" => "123"})
      %{metadata: %{"user_id" => "123"}}

      iex> OpenaiEx.Conversations.new(items: [%{type: "message", role: "user", content: [%{type: "input_text", text: "Hello"}]}])
      %{items: [%{type: "message", role: "user", content: [%{type: "input_text", text: "Hello"}]}]}

      iex> OpenaiEx.Conversations.new([])
      %{}
  """
  def new(args) when is_list(args) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args) when is_map(args) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Creates a new conversation.

  See https://platform.openai.com/docs/api-reference/conversations/create
  """
  def create!(openai = %OpenaiEx{}, request \\ %{}) do
    openai |> create(request) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, request \\ %{}) do
    openai |> Http.post(ep_url(), json: request)
  end

  @doc """
  Retrieves a specific conversation by ID.

  See https://platform.openai.com/docs/api-reference/conversations/retrieve
  """
  def retrieve!(openai = %OpenaiEx{}, conversation_id) do
    openai |> retrieve(conversation_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, conversation_id) do
    openai |> Http.get(ep_url(conversation_id))
  end

  @doc """
  Updates a conversation's metadata.

  See https://platform.openai.com/docs/api-reference/conversations/update
  """
  def update!(openai = %OpenaiEx{}, conversation_id, request) do
    openai |> update(conversation_id, request) |> Http.bang_it!()
  end

  def update(openai = %OpenaiEx{}, conversation_id, request) do
    openai |> Http.post(ep_url(conversation_id), json: request)
  end

  @doc """
  Deletes a conversation.

  See https://platform.openai.com/docs/api-reference/conversations/delete
  """
  def delete!(openai = %OpenaiEx{}, conversation_id) do
    openai |> delete(conversation_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, conversation_id) do
    openai |> Http.delete(ep_url(conversation_id))
  end
end
