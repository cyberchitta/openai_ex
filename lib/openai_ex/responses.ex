defmodule OpenaiEx.Responses do
  @moduledoc """
  This module provides an implementation of the OpenAI Responses API.
  The API reference can be found at https://platform.openai.com/docs/api-reference/responses.
  """
  alias OpenaiEx.{Http, HttpSse}

  @api_fields [
    :model,
    :background,
    :context_management,
    :conversation,
    :include,
    :input,
    :instructions,
    :max_output_tokens,
    :max_tool_calls,
    :metadata,
    :moderation,
    :parallel_tool_calls,
    :previous_response_id,
    :prompt,
    :prompt_cache_key,
    :prompt_cache_options,
    :prompt_cache_retention,
    :reasoning,
    :safety_identifier,
    :service_tier,
    :store,
    :stream_options,
    :temperature,
    :text,
    :tool_choice,
    :tools,
    :top_logprobs,
    :top_p,
    :truncation,
    :user
  ]

  @compact_fields [
    :model,
    :input,
    :instructions,
    :previous_response_id,
    :prompt_cache_key,
    :prompt_cache_options,
    :prompt_cache_retention,
    :service_tier
  ]

  @input_tokens_fields [
    :model,
    :conversation,
    :input,
    :instructions,
    :parallel_tool_calls,
    :personality,
    :previous_response_id,
    :reasoning,
    :text,
    :tool_choice,
    :tools,
    :truncation
  ]

  @query_params [
    :include
  ]

  defp ep_url(response_id \\ nil, action \\ nil) do
    "/responses" <>
      if(is_nil(response_id), do: "", else: "/#{response_id}") <>
      if(is_nil(action), do: "", else: "/#{action}")
  end

  @doc """
  Creates a new response.

  https://platform.openai.com/docs/api-reference/responses/create
  """
  def create!(openai = %OpenaiEx{}, params, stream: true) do
    openai |> create(params, stream: true) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, params, stream: true) do
    request_body = params |> Map.take(@api_fields) |> Map.put(:stream, true)
    openai |> HttpSse.post(ep_url(), json: request_body)
  end

  def create!(openai = %OpenaiEx{}, params) do
    openai |> create(params) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, params) do
    request_body = params |> Map.take(@api_fields)
    openai |> Http.post(ep_url(), json: request_body)
  end

  @doc """
  Retrieves a response.

  https://platform.openai.com/docs/api-reference/responses/retrieve
  """
  def retrieve!(openai = %OpenaiEx{}, opts) when is_list(opts) do
    openai |> retrieve(opts) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, opts) when is_list(opts) do
    response_id = Keyword.fetch!(opts, :response_id)
    params = opts |> Keyword.drop([:response_id]) |> Enum.into(%{}) |> Map.take(@query_params)
    openai |> Http.get(ep_url(response_id), params)
  end

  @doc """
  Deletes a response.

  See https://platform.openai.com/docs/api-reference/responses/delete
  """
  def delete!(openai = %OpenaiEx{}, response_id: response_id) do
    openai |> delete(response_id: response_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, response_id: response_id) do
    openai |> Http.delete(ep_url(response_id))
  end

  @doc """
  Cancels a background response.

  Only responses created with `background: true` can be cancelled.

  https://platform.openai.com/docs/api-reference/responses/cancel
  """
  def cancel!(openai = %OpenaiEx{}, response_id: response_id) do
    openai |> cancel(response_id: response_id) |> Http.bang_it!()
  end

  def cancel(openai = %OpenaiEx{}, response_id: response_id) do
    openai |> Http.post(ep_url(response_id, "cancel"))
  end

  @doc """
  Compacts a response, carrying prior state forward in fewer tokens.

  https://platform.openai.com/docs/api-reference/responses/compact
  """
  def compact!(openai = %OpenaiEx{}, params) do
    openai |> compact(params) |> Http.bang_it!()
  end

  def compact(openai = %OpenaiEx{}, params) do
    request_body = params |> Map.take(@compact_fields)
    openai |> Http.post(ep_url(nil, "compact"), json: request_body)
  end

  @doc """
  Returns the input token counts for a hypothetical response.

  https://platform.openai.com/docs/api-reference/responses/input_tokens
  """
  def input_tokens!(openai = %OpenaiEx{}, params) do
    openai |> input_tokens(params) |> Http.bang_it!()
  end

  def input_tokens(openai = %OpenaiEx{}, params) do
    request_body = params |> Map.take(@input_tokens_fields)
    openai |> Http.post(ep_url(nil, "input_tokens"), json: request_body)
  end

  @doc """
  Lists input items from a response. See https://platform.openai.com/docs/api-reference/responses/input-items
  """
  def input_items_list!(openai = %OpenaiEx{}, opts) when is_list(opts) do
    openai |> input_items_list(opts) |> Http.bang_it!()
  end

  def input_items_list(openai = %OpenaiEx{}, opts) when is_list(opts) do
    response_id = Keyword.fetch!(opts, :response_id)

    p =
      opts
      |> Keyword.drop([:response_id])
      |> Enum.into(%{})
      |> Map.take(OpenaiEx.list_query_fields())

    openai |> Http.get(ep_url(response_id, "input_items"), p)
  end
end
