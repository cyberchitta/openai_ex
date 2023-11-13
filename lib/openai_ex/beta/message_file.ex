defmodule OpenaiEx.Beta.Thread.Message.File do
  @moduledoc """
  This module provides an implementation of the OpenAI messages files API. The API reference can be found at https://platform.openai.com/docs/api-reference/messages.
  """

  defp ep_url(thread_id, message_id, file_id \\ nil) do
    "/threads/#{thread_id}/messages/#{message_id}/files" <>
      if is_nil(file_id), do: "", else: "/#{file_id}"
  end

  @doc """
  Calls the message file retrieve endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `params`: A map containing the fields of the message file retrieve request.

  ## Returns

  A map containing the fields of the specificied message file object.

  https://platform.openai.com/docs/api-reference/messages/getMessageFile
  """
  def retrieve(
        openai = %OpenaiEx{},
        _params = %{thread_id: thread_id, message_id: message_id, file_id: file_id}
      ) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(ep_url(thread_id, message_id, file_id))
  end

  @doc """
  Lists the files that belong to the specified thread message.

  https://platform.openai.com/docs/api-reference/messages/listMessageFiles
  """

  def list(openai = %OpenaiEx{}, params = %{thread_id: thread_id, message_id: message_id}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(
      ep_url(thread_id, message_id),
      params |> Map.take(OpenaiEx.list_query_fields())
    )
  end
end
