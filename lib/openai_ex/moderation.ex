defmodule OpenaiEx.Moderation do
  @moduledoc """
  This module provides an implementation of the OpenAI moderation API. The API reference can be found at https://platform.openai.com/docs/api-reference/moderations.

  ## API Fields

  The following fields can be used as parameters when creating a new moderation:

  - `:input`
  - `:model`
  """
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

      iex> OpenaiEx.Moderation.new(input: "This is a test")
      %{
        input: "This is a test"
      }

      iex> OpenaiEx.Moderation.new(%{input: "This is a test"})
      %{
        input: "This is a test"
      }
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{input: input}) do
    %{
      input: input
    }
    |> Map.merge(args)
    |> Map.take(@api_fields)
  end

  @doc """
  Calls the moderation endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration to use.
  - `moderation`: The moderation request to send.

  ## Returns

  A map containing the fields of the moderation response.
  """
  def create(openai = %OpenaiEx{}, moderation) do
    openai
    |> OpenaiEx.Http.post("/moderations", json: moderation |> Map.take(@api_fields))
  end
end
