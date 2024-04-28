defmodule OpenaiEx.Files do
  @moduledoc """
  This module provides an implementation of the OpenAI files API. The API reference can be found at https://platform.openai.com/docs/api-reference/files.

  ## API Fields

  The following fields can be used as parameters for various endpoints of the API:

  - `:file`
  - `:purpose`

  - `:file_id`
  """
  @api_fields [
    :file,
    :purpose,
    :file_id
  ]

  defp ep_url(file_id \\ nil, action \\ nil) do
    "/files" <>
      if(is_nil(file_id), do: "", else: "/#{file_id}") <>
      if(is_nil(action), do: "", else: "/#{action}")
  end

  @doc """
  Creates a new file upload request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the file upload request.

  ## Returns

  A map containing the fields of the file upload request.

  The `:file` and `:purpose` fields are required.
  """
  def new_upload(args = [_ | _]) do
    args |> Enum.into(%{}) |> new_upload()
  end

  def new_upload(args = %{file: _, purpose: _}) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Creates a new file retrieve / deletion / retrieve_content request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the file retrieve / deletion / retrieve_content request.

  ## Returns

  A map containing the fields of the file retrieve / deletion / retrieve_content request.

  The `:file_id` field is required.
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{file_id: _}) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Lists the files that belong to the user's organization.

  https://platform.openai.com/docs/api-reference/files/list
  """
  def list(openai = %OpenaiEx{}) do
    openai |> OpenaiEx.Http.get(ep_url())
  end

  @doc """
  Calls the file upload endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `upload`: A map containing the fields of the file upload request.

  ## Returns

  A map containing the fields of the file upload response.

  https://platform.openai.com/docs/api-reference/files/upload
  """
  def create(openai = %OpenaiEx{}, upload) do
    openai
    |> OpenaiEx.Http.post(ep_url(),
      multipart: upload |> OpenaiEx.Http.to_multi_part_form_data(file_fields())
    )
  end

  @doc """
  Calls the file delete endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `file_id`: The ID of the file to delete.

  ## Returns

  A map containing the fields of the file delete response.

  https://platform.openai.com/docs/api-reference/files/delete
  """
  def delete(openai = %OpenaiEx{}, file_id) do
    openai
    |> OpenaiEx.Http.delete(ep_url(file_id))
  end

  @doc """
  Calls the file retrieve endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `file_id`: The ID of the file to retrieve.

  ## Returns

  A map containing the fields of the file retrieve response.

  https://platform.openai.com/docs/api-reference/files/retrieve
  """
  def retrieve(openai = %OpenaiEx{}, file_id) do
    openai
    |> OpenaiEx.Http.get(ep_url(file_id))
  end

  @doc """
  Calls the file retrieve_content endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `file_id`: The ID of the file to retrieve the content of.

  ## Returns

  A map containing the fields of the file retrieve_content response.

  https://platform.openai.com/docs/api-reference/files/retrieve-content
  """
  def content(openai = %OpenaiEx{}, file_id) do
    openai
    |> OpenaiEx.Http.get_no_decode(ep_url(file_id, "content"))
  end

  @doc false
  def file_fields() do
    [:file]
  end
end
