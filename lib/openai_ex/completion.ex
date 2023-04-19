defmodule OpenaiEx.Completion do
  @moduledoc """
  This module provides an implementation of the OpenAI completions API. The API reference can be found at https://platform.openai.com/docs/api-reference/completions.

  ## API Fields

  The following fields can be used as parameters when creating a new completion:

  - `:model`
  - `:prompt`
  - `:suffix`
  - `:max_tokens`
  - `:temperature`
  - `:top_p`
  - `:n`
  - `:stream`
  - `:logprobs`
  - `:echo`
  - `:stop`
  - `:presence_penalty`
  - `:frequency_penalty`
  - `:best_of`
  - `:logit_bias`
  - `:user`
  """

  @api_fields [
    :model,
    :prompt,
    :suffix,
    :max_tokens,
    :temperature,
    :top_p,
    :n,
    :stream,
    :logprobs,
    :echo,
    :stop,
    :presence_penalty,
    :frequency_penalty,
    :best_of,
    :logit_bias,
    :user
  ]

  @doc """
  Creates a new completion request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the completion request.

  ## Returns

  A map containing the fields of the completion request.

  The `:model` field is required.

  Example usage:

      iex> _request = OpenaiEx.Completion.new(model: "davinci")
      %{model: "davinci"}

      iex> _request = OpenaiEx.Completion.new(%{model: "davinci"})
      %{model: "davinci"}
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{model: model}) do
    %{
      model: model
    }
    |> Map.merge(args)
    |> Map.take(@api_fields)
  end

  @doc """
  Calls the completion 'create' endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `completion`: The completion request, as a map with keys corresponding to the API fields.

  ## Returns

  A map containing the API response.

  See https://platform.openai.com/docs/api-reference/completions/create for more information.
  """
  def create(openai = %OpenaiEx{}, completion = %{}) do
    openai |> OpenaiEx.post("/completions", json: completion |> Map.take(@api_fields))
  end
end
