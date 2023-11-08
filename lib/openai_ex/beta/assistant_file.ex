defmodule OpenaiEx.Beta.Assistant.File do
  @moduledoc """
  This module provides an implementation of the OpenAI assistants files API. The API reference can be found at https://platform.openai.com/docs/api-reference/assistants.

  ## API Fields

  The following fields can be used as parameters for the assistant files API:

  - `:assistant_id`
  - `:file_id`

  """
  @api_fields [
    :assistant_id,
    :file_id
  ]

  @doc """
  Creates a new assistant file request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the assistant file request.

  ## Returns

  A map containing the fields of the assistant file request.
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{assistant_id: assistant_id}) do
    %{
      assistand_id: assistant_id
    }
    |> Map.merge(args)
    |> Map.take(@api_fields)
  end

  @beta_string "assistants=v1"

  @doc """
  Calls the assistant file create endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `params`: A map containing the fields of the assistant file create request.

  ## Returns

  A map containing the fields of the created assistant file object.

  https://platform.openai.com/docs/api-reference/assistants/createAssistantFile
  """
  def create(openai = %OpenaiEx{}, _params = %{assistant_id: assistant_id, file_id: file_id}) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.post("/assistants/#{assistant_id}/files",
      json: %{file_id: file_id} |> Map.take(@api_fields)
    )
  end

  @doc """
  Calls the assistant file retrieve endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `params`: A map containing the fields of the assistant file retrieve request.

  ## Returns

  A map containing the fields of the specificied assistant file object.

  https://platform.openai.com/docs/api-reference/assistants/getAssistantFile
  """
  def retrieve(openai = %OpenaiEx{}, _params = %{assistant_id: assistant_id, file_id: file_id}) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.get("/assistants/#{assistant_id}/files/#{file_id}")
  end

  @doc """
  Calls the assistant file delete endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `params`: A map containing the fields of the assistant file delete request.

  ## Returns

  A map containing the fields of the assistant file delete response.

  https://platform.openai.com/docs/api-reference/assistants/deleteAssistantFile
  """
  def delete(openai = %OpenaiEx{}, _params = %{assistant_id: assistant_id, file_id: file_id}) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.delete("/assistants/#{assistant_id}/files/#{file_id}")
  end

  @doc """
  Lists the files that belong to the specified assistant.

  https://platform.openai.com/docs/api-reference/files/list
  """
  @list_query_fields [
    :after,
    :before,
    :limit,
    :order
  ]

  def new_list(args = [_ | _]) do
    args |> Enum.into(%{}) |> new_list()
  end

  def new_list(args = %{assistant_id: assistant_id}) do
    %{
      assistant_id: assistant_id
    }
    |> Map.merge(args)
    |> Map.take([:assistant_id | @list_query_fields])
  end

  def list(openai = %OpenaiEx{}, params = %{assistant_id: assistant_id}) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.get(
      "/assistants/#{assistant_id}/files",
      params |> Map.take(@list_query_fields)
    )
  end
end
