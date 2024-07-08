defmodule OpenaiEx.Moderations do
  @moduledoc """
  This module provides an implementation of the OpenAI moderation API. The API reference can be found at https://platform.openai.com/docs/api-reference/moderations.
  """
  alias OpenaiEx.Http

  @api_fields [
    :input,
    :model
  ]

  @doc """
  Creates a new moderation request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the moderation request.

  ## Returns

  A map containing the fields of the moderation request.

  The `:input` field is required.

  Example usage:

      iex> OpenaiEx.Moderations.new(input: "This is a test")
      %{
        input: "This is a test"
      }

      iex> OpenaiEx.Moderations.new(%{input: "This is a test"})
      %{
        input: "This is a test"
      }
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{input: _}) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Calls the moderation endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration to use.
  - `moderation`: The moderation request to send.

  ## Returns

  A map containing the fields of the moderation response.
  """
  def create!(openai = %OpenaiEx{}, moderation) do
    openai |> create(moderation) |> Http.bang_it()
  end

  def create(openai = %OpenaiEx{}, moderation) do
    openai |> Http.post("/moderations", json: moderation |> Map.take(@api_fields))
  end
end
