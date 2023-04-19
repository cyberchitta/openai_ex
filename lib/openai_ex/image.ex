defmodule OpenaiEx.Image do
  @moduledoc """
  This module provides an implementation of the OpenAI images API. The API reference can be found at https://platform.openai.com/docs/api-reference/images.

  ## API Fields

  The following fields can be used as parameters when creating a new image:

  - `:prompt`
  - `:n`
  - `:size`
  - `:response_format`
  - `:user`
  """
  @api_fields [
    :prompt,
    :n,
    :size,
    :response_format,
    :user
  ]

  alias OpenaiEx.Image

  @doc """
  Creates a new image request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the image request.

  ## Returns

  A map containing the fields of the image request.

  The `:prompt` field is required.

  Example usage:

      iex> _request = OpenaiEx.Image.new([prompt: "This is a test"])
      %{prompt: "This is a test"}

      iex> _request = OpenaiEx.Image.new(%{prompt: "This is a test"})
      %{prompt: "This is a test"}
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{prompt: prompt}) do
    %{
      prompt: prompt
    }
    |> Map.merge(args)
    |> Map.take(@api_fields)
  end

  @doc """
  Calls the image generation endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration to use.
  - `image`: The image request to send.

  ## Returns

  A map containing the response from the OpenAI API.

  See the [OpenAI API Create Image reference](https://platform.openai.com/docs/api-reference/images/create) for more information.
  """
  def create(openai = %OpenaiEx{}, image = %{}) do
    openai |> OpenaiEx.post("/images/generations", json: image)
  end

  @doc """
  Calls the image edit endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration to use.
  - `image_edit`: The image edit request to send.

  ## Returns

  A map containing the response from the OpenAI API.

  See the [OpenAI API Create Image Edit reference](https://platform.openai.com/docs/api-reference/images/create-edit) for more information.
  """
  def create_edit(openai = %OpenaiEx{}, image_edit = %{}) do
    openai
    |> OpenaiEx.post("/images/edits",
      multipart: image_edit |> OpenaiEx.to_multi_part_form_data(Image.Edit.file_fields())
    )
  end

  @doc """
  Calls the image variation endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration to use.
  - `image_variation`: The image variation request to send.

  ## Returns

  A map containing the response from the OpenAI API.

  See the [OpenAI API Create Image Variation reference](https://platform.openai.com/docs/api-reference/images/create-variation) for more information.
  """
  def create_variation(openai = %OpenaiEx{}, image_variation = %{}) do
    openai
    |> OpenaiEx.post("/images/variations",
      multipart: image_variation |> OpenaiEx.to_multi_part_form_data(Image.Variation.file_fields())
    )
  end
end
