defmodule OpenaiEx.Beta.Threads.Messages do
  @moduledoc """
  This module provides an implementation of the OpenAI messages API. The API
  reference can be found at https://platform.openai.com/docs/api-reference/messages.
  """
  alias OpenaiEx.Http

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
  Creates a new message request
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args) do
    args |> Map.take([:thread_id | [:message_id | @api_fields]])
  end

  @doc """
  Calls the message create endpoint.

  https://platform.openai.com/docs/api-reference/messages/createMessage
  """
  def create!(openai = %OpenaiEx{}, thread_id, params) do
    openai |> create(thread_id, params) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, thread_id, params = %{role: _, content: _}) do
    json = params |> Map.take(@api_fields)
    openai |> OpenaiEx.with_assistants_beta() |> Http.post(ep_url(thread_id), json: json)
  end

  @doc """
  Calls the message retrieve endpoint.

  https://platform.openai.com/docs/api-reference/messages/getMessage
  """
  def retrieve!(openai = %OpenaiEx{}, params = %{thread_id: _, message_id: _}) do
    openai |> retrieve(params) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, %{thread_id: thread_id, message_id: message_id}) do
    openai |> OpenaiEx.with_assistants_beta() |> Http.get(ep_url(thread_id, message_id))
  end

  @doc """
  Calls the message update endpoint.

  https://platform.openai.com/docs/api-reference/messages/modifyMessage
  """
  def update!(openai = %OpenaiEx{}, params = %{thread_id: _, message_id: _, metadata: _}) do
    openai |> update(params) |> Http.bang_it!()
  end

  def update(openai = %OpenaiEx{}, %{
        thread_id: thread_id,
        message_id: message_id,
        metadata: metadata
      }) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> Http.post(ep_url(thread_id, message_id), json: %{metadata: metadata})
  end

  def delete!(openai = %OpenaiEx{}, thread_id, message_id) do
    openai |> delete(thread_id, message_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, thread_id, message_id) do
    openai |> OpenaiEx.with_assistants_beta() |> Http.delete(ep_url(thread_id, message_id))
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

  def list!(openai = %OpenaiEx{}, thread_id, params = %{} \\ %{}) do
    openai |> list(thread_id, params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, thread_id, params = %{} \\ %{}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> Http.get(ep_url(thread_id), params |> Map.take([:run_id | OpenaiEx.list_query_fields()]))
  end
end
