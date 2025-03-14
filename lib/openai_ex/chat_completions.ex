defmodule OpenaiEx.Chat.Completions do
  @moduledoc """
  This module provides an implementation of the OpenAI chat completions API. The API reference can be found at https://platform.openai.com/docs/api-reference/chat/completions.
  """
  alias OpenaiEx.{Http, HttpSse}

  @api_fields [
    :messages,
    :model,
    :audio,
    :frequency_penalty,
    :logit_bias,
    :logprobs,
    :max_completion_tokens,
    :max_tokens,
    :metadata,
    :modalities,
    :n,
    :parallel_tool_calls,
    :prediction,
    :presence_penalty,
    :reasoning_effort,
    :response_format,
    :seed,
    :service_tier,
    :stop,
    :store,
    :stream_options,
    :temperature,
    :top_p,
    :top_logprobs,
    :tools,
    :tool_choice,
    :user,
    :web_search_options
  ]

  @doc """
  Creates a new chat completion request

  Example usage:

      iex> _request = OpenaiEx.Chat.Completions.new(model: "davinci", messages: [OpenaiEx.ChatMessage.user("Hello, world!")])
      %{messages: [%{content: "Hello, world!", role: "user"}], model: "davinci"}

      iex> _request = OpenaiEx.Chat.Completions.new(%{model: "davinci", messages: [OpenaiEx.ChatMessage.user("Hello, world!")]})
      %{messages: [%{content: "Hello, world!", role: "user"}], model: "davinci"}
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{model: _, messages: _}) do
    args |> Map.take(@api_fields)
  end

  @ep_url "/chat/completions"

  @doc """
  Calls the chat completion 'create' endpoint.

  See https://platform.openai.com/docs/api-reference/chat/completions/create for more information.
  """
  def create!(openai = %OpenaiEx{}, chat_completion = %{}, stream: true) do
    openai |> create(chat_completion, stream: true) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, chat_completion = %{}, stream: true) do
    ep = Map.get(openai, :_ep_path_mapping).(@ep_url)

    openai
    |> HttpSse.post(ep, json: chat_completion |> Map.take(@api_fields) |> Map.put(:stream, true))
  end

  def create!(openai = %OpenaiEx{}, chat_completion = %{}) do
    openai |> create(chat_completion) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, chat_completion = %{}) do
    ep = Map.get(openai, :_ep_path_mapping).(@ep_url)
    openai |> Http.post(ep, json: chat_completion |> Map.take(@api_fields))
  end
end
