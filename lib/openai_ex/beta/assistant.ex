defmodule OpenaiEx.Beta.Assistant do
  @moduledoc """
  This module provides an implementation of the OpenAI assistants API. The API reference can be found at https://platform.openai.com/docs/api-reference/assistants.

  ## API Fields

  The following fields can be used as parameters when creating a new assistant:

  - `:model`
  - `:name`
  - `:description`
  - `:instructions`
  - `:tools`
  - `:file_ids`
  - `:metadata`

  """
  @api_fields [
    :model,
    :name,
    :description,
    :instructions,
    :tools,
    :file_ids,
    :metadata
  ]

  @doc """
  Creates a new assistants request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the assistant request.

  ## Returns

  A map containing the fields of the assistant request.

  The `:model` field is required.

  Example usage:

      iex> _request = OpenaiEx.Beta.Assistant.new(model: "gpt-4-turbo")
      %{model: "gpt-4-turbo"}

      iex> _request = OpenaiEx.Beta.Assistant.new(%{model: "gpt-4-turbo"})
      %{model: "gpt-4-turbo"}
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{model: model}) do
    %{
      model: model
    }
    |> Map.merge(args)
    |> Map.take(@api_fields)
  end

  @completion_url "/assistants"

  @beta_string "assistants=v1"

  @doc """
  Calls the assistant 'create' endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `assistant`: The assistant request, as a map with keys corresponding to the API fields.

  ## Returns

  A map containing the API response.

  See https://platform.openai.com/docs/api-reference/assistants/createAssistant for more information.
  """
  def create(openai = %OpenaiEx{}, assistant = %{}) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.post(@completion_url, json: assistant |> Map.take(@api_fields))
  end

  @doc """
  Calls the assistant retrieve endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `assistant_id`: The ID of the assistant to retrieve.

  ## Returns

  A map containing the fields of the file retrieve response.

  https://platform.openai.com/docs/api-reference/assistants/getAssistant
  """
  def retrieve(openai = %OpenaiEx{}, assistant_id) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.get("#{@completion_url}/#{assistant_id}")
  end

  @doc """
  Calls the assistant 'update' endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `assistant`: The assistant request, as a map with keys corresponding to the API fields.

  ## Returns

  A map containing the API response.

  See https://platform.openai.com/docs/api-reference/assistants/modifyAssistant for more information.
  """
  def update(openai = %OpenaiEx{}, assistant_id, assistant = %{}) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.post("#{@completion_url}/#{assistant_id}",
      json: assistant |> Map.take(@api_fields)
    )
  end

  @doc """
  Calls the assistant delete endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `assistant_id`: The ID of the file to delete.

  ## Returns

  A map containing the fields of the assistant delete response.

  https://platform.openai.com/docs/api-reference/assistants/deleteAssistant
  """
  def delete(openai = %OpenaiEx{}, assistant_id) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.delete("#{@completion_url}/#{assistant_id}")
  end

  @doc """
  Creates a new list assistants request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the list assistants request.

  ## Returns

  A map containing the fields of the list assistants request.
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

  def new_list(args = %{}) do
    args
    |> Map.take(@list_query_fields)
  end

  @doc """
  Returns a list of assistant objects.

  https://platform.openai.com/docs/api-reference/assistants/listAssistants
  """
  def list(openai = %OpenaiEx{}, params = %{} \\ %{}) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.get(@completion_url, params |> Map.take(@list_query_fields))
  end
end
