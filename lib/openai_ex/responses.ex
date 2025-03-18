defmodule OpenaiEx.Responses do
  @moduledoc """
  This module provides an implementation of the OpenAI Responses API.
  The API reference can be found at https://platform.openai.com/docs/api-reference/responses.
  """
  alias OpenaiEx.{Http, HttpSse}

  @api_fields [
    :model,
    :input,
    :include,
    :instructions,
    :max_output_tokens,
    :metadata,
    :parallel_tool_calls,
    :previous_response_id,
    :reasoning,
    :store,
    :temperature,
    :text,
    :tool_choice,
    :tools,
    :top_p,
    :truncation,
    :user
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
  def retrieve!(openai = %OpenaiEx{}, response_id: response_id) do
    openai |> retrieve(response_id: response_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, response_id: response_id) do
    openai |> Http.get(ep_url(response_id))
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
  def input_items_list!(openai = %OpenaiEx{}, response_id, opts \\ []) do
    openai |> input_items_list(response_id, opts) |> Http.bang_it!()
  end

  def input_items_list(openai = %OpenaiEx{}, response_id, opts \\ []) do
    params = opts |> Enum.into(%{}) |> Map.take(OpenaiEx.list_query_fields())
    openai |> Http.get(ep_url(response_id) <> "/input_items", params)
  end
end
