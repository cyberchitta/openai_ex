defmodule OpenaiEx.Images do
  @moduledoc """
  This module provides an implementation of the OpenAI images API. The API reference can be found at https://platform.openai.com/docs/api-reference/images.
  """
  alias OpenaiEx.{Images, Http}

  @doc """
  Calls the image generation endpoint.

  See the [OpenAI API Create Image reference](https://platform.openai.com/docs/api-reference/images/create) for more information.
  """
  def generate!(openai = %OpenaiEx{}, image = %{}) do
    openai |> generate(image) |> Http.bang_it!()
  end

  def generate(openai = %OpenaiEx{}, image = %{}) do
    openai |> Http.post("/images/generations", json: image)
  end

  @doc """
  Calls the image edit endpoint.

  See the [OpenAI API Create Image Edit reference](https://platform.openai.com/docs/api-reference/images/create-edit) for more information.
  """
  def edit!(openai = %OpenaiEx{}, image_edit = %{}) do
    openai |> edit(image_edit) |> Http.bang_it!()
  end

  def edit(openai = %OpenaiEx{}, image_edit = %{}) do
    multipart = image_edit |> Http.to_multi_part_form_data(Images.Edit.file_fields())
    openai |> Http.post("/images/edits", multipart: multipart)
  end

  @doc """
  Calls the image variation endpoint.

  See the [OpenAI API Create Image Variation reference](https://platform.openai.com/docs/api-reference/images/create-variation) for more information.
  """
  def create_variation!(openai = %OpenaiEx{}, image_variation = %{}) do
    openai |> create_variation(image_variation) |> Http.bang_it!()
  end

  def create_variation(openai = %OpenaiEx{}, image_variation = %{}) do
    multipart = image_variation |> Http.to_multi_part_form_data(Images.Variation.file_fields())
    openai |> Http.post("/images/variations", multipart: multipart)
  end
end
