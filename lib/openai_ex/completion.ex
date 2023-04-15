defmodule OpenaiEx.Completion do
  @moduledoc """
  https://platform.openai.com/docs/api-reference/completions
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

  def new(opts \\ []) do
    map = opts |> Enum.into(%{})
    new(map |> Map.get(:model), map |> Map.get(:prompt), map |> Map.drop([:model, :prompt]))
  end

  def new(model, prompt, opts \\ %{}) do
    %{
      model: model,
      prompt: prompt
    }
    |> Map.merge(opts)
    |> Map.take(@api_fields)
  end

  @doc """
  https://platform.openai.com/docs/api-reference/completions/create
  """
  def create(openai = %OpenaiEx{}, completion = %{}) do
    openai
    |> OpenaiEx.req()
    |> Req.post!(url: "/completions", json: completion |> Map.take(@api_fields))
    |> Map.get(:body)
  end
end
