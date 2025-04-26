defmodule OpenaiEx.Images.Variation do
  @moduledoc """
  This module provides constructors for OpenAI Image Variation API request structure. The API reference can be found at https://platform.openai.com/docs/api-reference/images/create-variation.
  """
  @api_fields [
    :image,
    :model,
    :n,
    :response_format,
    :size,
    :user
  ]

  @doc """
  Creates a new image variation request
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
