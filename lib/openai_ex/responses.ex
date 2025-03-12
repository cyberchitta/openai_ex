defmodule OpenaiEx.Responses do
  @moduledoc """
  This module provides an implementation of the OpenAI Responses API.
  The API reference can be found at https://platform.openai.com/docs/api-reference/responses.
  """
  alias OpenaiEx.{Http, HttpSse}

  @api_fields [
    :model,
    :input,
    :instructions,
    :tools,
    :store,
    :previous_response_id
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
end
