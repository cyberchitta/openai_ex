defmodule OpenaiEx.Image do
  @moduledoc """
  This module provides an implementation of the OpenAI images API. The API reference can be found at https://platform.openai.com/docs/api-reference/images.
  """
  alias OpenaiEx.Image

  @doc """
  Calls the image generation endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration to use.
  - `image`: The image request to send.

  ## Returns

  A map containing the response from the OpenAI API.

  See the [OpenAI API Create Image reference](https://platform.openai.com/docs/api-reference/images/create) for more information.
  """
  def generate(openai = %OpenaiEx{}, image = %{}) do
    openai |> OpenaiEx.Http.post("/images/generations", json: image)
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
  def edit(openai = %OpenaiEx{}, image_edit = %{}) do
    openai
    |> OpenaiEx.Http.post("/images/edits",
      multipart: image_edit |> OpenaiEx.Http.to_multi_part_form_data(Image.Edit.file_fields())
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
    |> OpenaiEx.Http.post("/images/variations",
      multipart:
        image_variation |> OpenaiEx.Http.to_multi_part_form_data(Image.Variation.file_fields())
    )
  end
end
