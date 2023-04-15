defmodule OpenaiEx.ChatCompletion do
  @moduledoc """
  https://platform.openai.com/docs/api-reference/chat/completions
  """
  @api_fields [
    :model,
    :messages,
    :temperature,
    :top_p,
    :n,
    :stream,
    :stop,
    :max_tokens,
    :presence_penalty,
    :frequency_penalty,
    :logit_bias,
    :user
  ]

  def new(model, messages, opts \\ %{}) do
    %{
      model: model,
      messages: messages
    }
    |> Map.merge(opts)
    |> Map.take(@api_fields)
  end

  @doc """
  https://platform.openai.com/docs/api-reference/chat/completions/create
  """
  def create(openai = %OpenaiEx{}, chat_completion = %{}) do
    openai
    |> OpenaiEx.req()
    |> Req.post!(url: "/chat/completions", json: chat_completion |> Map.take(@api_fields))
    |> Map.get(:body)
  end
end
