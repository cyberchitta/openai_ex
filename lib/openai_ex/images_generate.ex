defmodule OpenaiEx.Images.Generate do
  @moduledoc """
  This module provides constructors for the OpenAI image generation API. The API
  reference can be found at https://platform.openai.com/docs/api-reference/images/create.

  ## API Fields

  The following fields can be used as parameters when creating a new image:

  - `:prompt`
  - `:model`
  - `:n`
  - `:quality`
  - `:response_format`
  - `:size`
  - `:style`
  - `:user`
  """
  @api_fields [
    :prompt,
    :model,
    :n,
    :quality,
    :response_format,
    :size,
    :style,
    :user
  ]

  @doc """
  Creates a new image generation request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the image generation request.

  ## Returns

  A map containing the fields of the image generation request.

  The `:prompt` field is required.

  Example usage:

      iex> _request = OpenaiEx.Images.Generate.new(prompt: "This is a test")
      %{prompt: "This is a test"}

      iex> _request = OpenaiEx.Images.Generate.new(%{prompt: "This is a test"})
      %{prompt: "This is a test"}
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{prompt: _}) do
    args |> Map.take(@api_fields)
  end
end
