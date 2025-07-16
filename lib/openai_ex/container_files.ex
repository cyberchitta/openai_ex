defmodule OpenaiEx.ContainerFiles do
  @moduledoc """
  This module provides an implementation of the OpenAI Container Files API. The API reference can be found at https://platform.openai.com/docs/api-reference/container-files.
  """

  alias OpenaiEx.Http

  defp ep_url(container_id, file_id \\ nil, action \\ nil) do
    base = "/containers/#{container_id}/files"

    base
    |> append_file_id(file_id)
    |> append_action(action)
  end

  defp append_file_id(url, nil), do: url
  defp append_file_id(url, file_id), do: "#{url}/#{file_id}"

  defp append_action(url, nil), do: url
  defp append_action(url, action), do: "#{url}/#{action}"

  @doc """
  Creates a new file upload request with the given arguments.

  ## Examples

      iex> OpenaiEx.ContainerFiles.new_upload(file: {"test.txt", "content"})
      %{file: {"test.txt", "content"}}

      iex> OpenaiEx.ContainerFiles.new_upload(file: {"/path/to/file.txt"})
      %{file: {"/path/to/file.txt"}}
  """
  def new_upload(args) when is_list(args) do
    args |> Enum.into(%{}) |> new_upload()
  end

  def new_upload(args) when is_map(args) do
    args |> Map.take([:file]) |> validate_upload_request()
  end

  @doc """
  Creates a new file reference request with the given arguments.

  Example usage:

      iex> OpenaiEx.ContainerFiles.new_reference(file_id: "file-123")
      %{file_id: "file-123"}
  """
  def new_reference(args) when is_list(args) do
    args |> Enum.into(%{}) |> new_reference()
  end

  def new_reference(args) when is_map(args) do
    args |> Map.take([:file_id]) |> validate_reference_request()
  end

  defp validate_upload_request(request) do
    if Map.has_key?(request, :file) do
      request
    else
      raise ArgumentError, "Upload request must include :file"
    end
  end

  defp validate_reference_request(request) do
    if Map.has_key?(request, :file_id) do
      request
    else
      raise ArgumentError, "Reference request must include :file_id"
    end
  end

  @doc """
  Lists all files in a container.

  See https://platform.openai.com/docs/api-reference/container-files/listContainerFiles
  """
  def list!(openai = %OpenaiEx{}, container_id, params \\ %{}) do
    openai |> list(container_id, params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, container_id, params \\ %{}) do
    query_params = params |> Map.take(OpenaiEx.list_query_fields())
    openai |> Http.get(ep_url(container_id), query_params)
  end

  @doc """
  Creates a new container file via upload or file reference. 

  See https://platform.openai.com/docs/api-reference/container-files/createContainerFile
  """
  def create!(openai = %OpenaiEx{}, container_id, request) do
    openai |> create(container_id, request) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, container_id, request) do
    cond do
      Map.has_key?(request, :file) ->
        # Handle file upload with multipart
        multipart = request |> Http.to_multi_part_form_data([:file])
        openai |> Http.post(ep_url(container_id), multipart: multipart)

      Map.has_key?(request, :file_id) ->
        # Handle file reference with JSON
        openai |> Http.post(ep_url(container_id), json: request)

      true ->
        {:error, "Request must include either :file or :file_id"}
    end
  end

  @doc """
  Retrieves a specific container file by ID.

  See https://platform.openai.com/docs/api-reference/container-files/retrieveContainerFile
  """
  def retrieve!(openai = %OpenaiEx{}, container_id, file_id) do
    openai |> retrieve(container_id, file_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, container_id, file_id) do
    openai |> Http.get(ep_url(container_id, file_id))
  end

  @doc """
  Retrieves the content of a container file.

  See https://platform.openai.com/docs/api-reference/container-files/retrieveContainerFileContent
  """
  def content!(openai = %OpenaiEx{}, container_id, file_id) do
    openai |> content(container_id, file_id) |> Http.bang_it!()
  end

  def content(openai = %OpenaiEx{}, container_id, file_id) do
    openai |> Http.get_no_decode(ep_url(container_id, file_id, "content"))
  end

  @doc """
  Deletes a container file.

  See https://platform.openai.com/docs/api-reference/container-files/deleteContainerFile
  """
  def delete!(openai = %OpenaiEx{}, container_id, file_id) do
    openai |> delete(container_id, file_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, container_id, file_id) do
    openai |> Http.delete(ep_url(container_id, file_id))
  end

  @doc false
  def file_fields() do
    [:file]
  end
end
