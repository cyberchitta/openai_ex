defmodule OpenaiEx.Completion do
  @moduledoc """
  This module provides an implementation of the OpenAI completions API. The API reference can be found at https://platform.openai.com/docs/api-reference/completions.

  ## API Fields

  The following fields can be used as parameters when creating a new completion:

  - `:model`
  - `:prompt`
  - `:best_of`
  - `:echo`
  - `:frequency_penalty`
  - `:logit_bias`
  - `:logprobs`
  - `:max_tokens`
  - `:n`
  - `:presence_penalty`
  - `:stop`
  - `:suffix`
  - `:temperature`
  - `:top_p`
  - `:user`
  """

  @api_fields [
    :model,
    :prompt,
    :best_of,
    :echo,
    :frequency_penalty,
    :logit_bias,
    :logprobs,
    :max_tokens,
    :n,
    :presence_penalty,
    :stop,
    :suffix,
    :temperature,
    :top_p,
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
    args |> Map.take(@api_fields)
  end

  @ep_url "/completions"

  @doc """
  Calls the completion 'create' endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `completion`: The completion request, as a map with keys corresponding to the API fields.

  ## Returns

  A map containing the API response.

  See https://platform.openai.com/docs/api-reference/completions/create for more information.
  """
  def create(openai = %OpenaiEx{}, completion = %{}, stream: true) do
    openai
    |> OpenaiEx.HttpSse.post(@ep_url,
      json: completion |> Map.take(@api_fields) |> Map.put(:stream, true)
    )
  end

  def create(openai = %OpenaiEx{}, completion = %{}) do
    openai |> OpenaiEx.Http.post(@ep_url, json: completion |> Map.take(@api_fields))
  end
end
