defmodule OpenaiEx.Images.Edit do
  @moduledoc """
  This module provides constructors for OpenAI Image Edit API request structure. The API reference can be found at https://platform.openai.com/docs/api-reference/images/create-edit.
  """
  @api_fields [
    :image,
    :prompt,
    :mask,
    :n,
    :size,
    :response_format,
    :user
  ]

  @doc """
  Creates a new image edit request
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{image: _, prompt: _}) do
    args |> Map.take(@api_fields)
  end

  @doc false
  def file_fields() do
    [:image, :mask]
  end
end
