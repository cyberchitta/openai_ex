defmodule OpenaiEx.Images.Variation do
  @moduledoc """
  This module provides constructors for OpenAI Image Variation API request structure. The API reference can be found at https://platform.openai.com/docs/api-reference/images/create-variation.

  ## API Fields

  - `:image`
  - `:n`
  - `:size`
  - `:response_format`
  - `:user`
  """
  @api_fields [
    :image,
    :n,
    :size,
    :response_format,
    :user
  ]

  @doc """
  Creates a new image variation request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the image variation request.

  ## Returns

  A map containing the fields of the image variation request.

  The `:image` field is required.
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{image: _}) do
    args |> Map.take(@api_fields)
  end

  @doc false
  def file_fields() do
    [:image]
  end
end
