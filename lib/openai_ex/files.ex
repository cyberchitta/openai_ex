defmodule OpenaiEx.Files do
  @moduledoc """
  This module provides an implementation of the OpenAI files API. The API reference can be found at https://platform.openai.com/docs/api-reference/files.
  """
  alias OpenaiEx.Http

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
  """
  def new_upload(args = [_ | _]) do
    args |> Enum.into(%{}) |> new_upload()
  end

  def new_upload(args = %{file: _, purpose: _}) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Creates a new file retrieve / deletion / retrieve_content request
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
  def list!(openai = %OpenaiEx{}) do
    openai |> list() |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}) do
    openai |> Http.get(ep_url())
  end

  @doc """
  Calls the file upload endpoint.

  https://platform.openai.com/docs/api-reference/files/upload
  """
  def create!(openai = %OpenaiEx{}, upload) do
    openai |> create(upload) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, upload) do
    multipart = upload |> Http.to_multi_part_form_data(file_fields())
    openai |> Http.post(ep_url(), multipart: multipart)
  end

  @doc """
  Calls the file delete endpoint.

  https://platform.openai.com/docs/api-reference/files/delete
  """
  def delete!(openai = %OpenaiEx{}, file_id) do
    openai |> delete(file_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, file_id) do
    openai |> Http.delete(ep_url(file_id))
  end

  @doc """
  Calls the file retrieve endpoint.

  https://platform.openai.com/docs/api-reference/files/retrieve
  """
  def retrieve!(openai = %OpenaiEx{}, file_id) do
    openai |> retrieve(file_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, file_id) do
    openai |> Http.get(ep_url(file_id))
  end

  @doc """
  Calls the file retrieve_content endpoint.

  https://platform.openai.com/docs/api-reference/files/retrieve-content
  """
  def content!(openai = %OpenaiEx{}, file_id) do
    openai |> content(file_id) |> Http.bang_it!()
  end

  def content(openai = %OpenaiEx{}, file_id) do
    openai |> Http.get_no_decode(ep_url(file_id, "content"))
  end

  @doc false
  def file_fields() do
    [:file]
  end
end
