defmodule OpenaiEx.Embedding do
  @moduledoc """
  This module provides an implementation of the OpenAI embeddings API. The API reference can be found at https://platform.openai.com/docs/api-reference/embeddings.

  ## API Fields

  The following fields can be used as parameters when creating a new embedding:

  - `:model`
  - `:input`
  - `:user`
  """
  @api_fields [
    :model,
    :input,
    :user
  ]

  @doc """
  Creates a new embedding request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the embedding request.

  ## Returns

  A map containing the fields of the embedding request.

  The `:model` and `:input` fields are required.

  Example usage:

      iex> _request = OpenaiEx.Embedding.new([model: "davinci", input: "This is a test"])
      %{input: "This is a test", model: "davinci"}

      iex> _request = OpenaiEx.Embedding.new(%{model: "davinci", input: "This is a test"})
      %{input: "This is a test", model: "davinci"}
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{model: model, input: input}) do
    %{
      model: model,
      input: input
    }
    |> Map.merge(args)
    |> Map.take(@api_fields)
  end

  @doc """
  Calls the embedding endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration to use.
  - `embedding`: The embedding request to send.

  ## Returns

  A map containing the fields of the embedding response.

  See https://platform.openai.com/docs/api-reference/embeddings/create for more information.
  """
  def create(openai = %OpenaiEx{}, embedding = %{}) do
    openai |> OpenaiEx.post("/embeddings", json: embedding)
  end
end
