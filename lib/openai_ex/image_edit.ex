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

  @doc false
  def file_fields() do
    [:image, :mask]
  end
end
