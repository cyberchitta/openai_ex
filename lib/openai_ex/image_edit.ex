defmodule OpenaiEx.Image.Edit do
  @moduledoc """
  This module provides constructors for OpenAI Image Edit API request structure. The API reference can be found at https://platform.openai.com/docs/api-reference/images/create-edit.

  ## API Fields

  - `:image`
  - `:mask`
  - `:prompt`
  - `:n`
  - `:size`
  - `:response_format`
  - `:user`
  """
  @api_fields [
    :image,
    :mask,
    :prompt,
    :n,
    :size,
    :response_format,
    :user
  ]

  @doc """
  Creates a new image edit request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the image edit request.

  ## Returns

  A map containing the fields of the image edit request.

  The `:image` and `:prompt` fields are required.
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{image: image, prompt: prompt}) do
    %{
      image: image,
      prompt: prompt
    }
    |> Map.merge(args)
    |> Map.take(@api_fields)
  end

  alias Tesla.Multipart

  def to_multi_part_form_data(img_edit) do
    mp =
      img_edit
      |> Map.drop([:image, :mask])
      |> Enum.reduce(Multipart.new(), fn {k, v}, acc ->
        acc |> Multipart.add_field(to_string(k), v)
      end)

    img_edit
    |> Map.take([:image, :mask])
    |> Enum.reduce(mp, fn {k, v}, acc ->
      acc |> Multipart.add_file_content(v, "", name: to_string(k))
    end)
  end
end
