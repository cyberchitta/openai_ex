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

  defp ep_url(completion_id \\ nil, action \\ nil) do
    @ep_url <>
      if(is_nil(completion_id), do: "", else: "/#{completion_id}") <>
      if(is_nil(action), do: "", else: "/#{action}")
  end

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

  @doc """
  Retrieves a stored chat completion by ID.

  See https://platform.openai.com/docs/api-reference/chat/get
  """
  def retrieve!(openai = %OpenaiEx{}, completion_id: completion_id) do
    openai |> retrieve(completion_id: completion_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, completion_id: completion_id) do
    openai |> Http.get(ep_url(completion_id))
  end

  @doc """
  Lists messages from a stored chat completion.

  See https://platform.openai.com/docs/api-reference/chat/getMessages
  """
  def messages_list!(openai = %OpenaiEx{}, completion_id, opts \\ []) do
    openai |> messages_list(completion_id, opts) |> Http.bang_it!()
  end

  def messages_list(openai = %OpenaiEx{}, completion_id, opts \\ []) do
    params = opts |> Enum.into(%{}) |> Map.take(OpenaiEx.list_query_fields())
    openai |> Http.get(ep_url(completion_id, "messages"), params)
  end

  @doc """
  Lists stored Chat Completions.

  See https://platform.openai.com/docs/api-reference/chat/list
  """
  def list!(openai = %OpenaiEx{}, opts \\ []) do
    openai |> list(opts) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, opts \\ []) do
    p = opts |> Enum.into(%{}) |> Map.take(OpenaiEx.list_query_fields() ++ [:metadata, :model])
    openai |> Http.get(ep_url(), p)
  end

  @doc """
  Updates a stored chat completion.

  See https://platform.openai.com/docs/api-reference/chat/update
  """
  def update!(openai = %OpenaiEx{}, completion_id: completion_id, metadata: metadata) do
    openai |> update(completion_id: completion_id, metadata: metadata) |> Http.bang_it!()
  end

  def update(openai = %OpenaiEx{}, completion_id: completion_id, metadata: metadata) do
    openai |> Http.post(ep_url(completion_id), json: %{metadata: metadata})
  end

  @doc """
  Deletes a stored chat completion.

  See https://platform.openai.com/docs/api-reference/chat/delete
  """
  def delete!(openai = %OpenaiEx{}, completion_id: completion_id) do
    openai |> delete(completion_id: completion_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, completion_id: completion_id) do
    openai |> Http.delete(ep_url(completion_id))
  end
end
