defmodule OpenaiEx.Completion do
  @moduledoc """
  This module provides an implementation of the OpenAI completions API. The API reference can be found at https://platform.openai.com/docs/api-reference/completions.
  """
  alias OpenaiEx.{Http, HttpSse}

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

  Example usage:
      iex> _request = OpenaiEx.Completion.new(model: "davinci")
      %{model: "davinci"}
      iex> _request = OpenaiEx.Completion.new(%{model: "davinci"})
      %{model: "davinci"}
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{model: _}) do
    args |> Map.take(@api_fields)
  end

  @ep_url "/completions"

  @doc """
  Calls the completion 'create' endpoint.

  See https://platform.openai.com/docs/api-reference/completions/create for more information.
  """
  def create!(openai = %OpenaiEx{}, completion = %{}, stream: true) do
    openai |> create(completion, stream: true) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, completion = %{}, stream: true) do
    ep = Map.get(openai, :_ep_path_mapping).(@ep_url)

    openai
    |> HttpSse.post(ep, json: completion |> Map.take(@api_fields) |> Map.put(:stream, true))
  end

  def create!(openai = %OpenaiEx{}, completion = %{}) do
    openai |> create(completion) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, completion = %{}) do
    ep = Map.get(openai, :_ep_path_mapping).(@ep_url)
    openai |> Http.post(ep, json: completion |> Map.take(@api_fields))
  end
end
