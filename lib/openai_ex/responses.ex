defmodule OpenaiEx.Responses do
  @moduledoc """
  This module provides an implementation of the OpenAI Responses API.
  The API reference can be found at https://platform.openai.com/docs/api-reference/responses.
  """
  alias OpenaiEx.{Http, HttpSse}

  @api_fields [
    :model,
    :background,
    :conversation,
    :include,
    :input,
    :instructions,
    :max_output_tokens,
    :max_tool_calls,
    :metadata,
    :parallel_tool_calls,
    :previous_response_id,
    :prompt,
    :prompt_cache_key,
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

  @query_params [
    :include
  ]

  defp ep_url(response_id \\ nil) do
    "/responses" <> if(is_nil(response_id), do: "", else: "/#{response_id}")
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

    openai |> Http.get(ep_url(response_id) <> "/input_items", p)
  end
end
