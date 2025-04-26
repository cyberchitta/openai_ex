defmodule OpenaiEx.Images.Generate do
  @moduledoc """
  This module provides constructors for the OpenAI image generation API. The API
  reference can be found at https://platform.openai.com/docs/api-reference/images/create.
  """
  @api_fields [
    :prompt,
    :background,
    :model,
    :moderation,
    :n,
    :output_compression,
    :output_format,
    :quality,
    :response_format,
    :size,
    :style,
    :user
  ]

  @doc """
  Creates a new image generation request

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
