defmodule OpenaiEx.Batches do
  @moduledoc """
  This module provides an implementation of the OpenAI Batch API. The API reference can be found at https://platform.openai.com/docs/api-reference/batch.
  """

  alias OpenaiEx.Http

  @api_fields [
    :input_file_id,
    :completion_window,
    :endpoint,
    :metadata,
    :after,
    :limit
  ]

  defp ep_url(batch_id \\ nil, action \\ nil) do
    "/batches" <>
      if(is_nil(batch_id), do: "", else: "/#{batch_id}") <>
      if(is_nil(action), do: "", else: "/#{action}")
  end

  @doc """
  Creates a new batch request
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{}) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Creates and executes a batch from an uploaded file of requests.

  https://platform.openai.com/docs/api-reference/batch/create
  """
  def create!(openai = %OpenaiEx{}, batch = %{}) do
    openai |> create(batch) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, batch = %{}) do
    openai |> Http.post(ep_url(), json: batch)
  end

  @doc """
  Retrieves a batch.

  https://platform.openai.com/docs/api-reference/batch/retrieve
  """
  def retrieve!(openai = %OpenaiEx{}, batch_id: batch_id) do
    openai |> retrieve(batch_id: batch_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, batch_id: batch_id) do
    openai |> Http.get(ep_url(batch_id))
  end

  @doc """
  Cancels an in-progress batch.

  https://platform.openai.com/docs/api-reference/batch/cancel
  """
  def cancel!(openai = %OpenaiEx{}, batch_id: batch_id) do
    openai |> cancel(batch_id: batch_id) |> Http.bang_it!()
  end

  def cancel(openai = %OpenaiEx{}, batch_id: batch_id) do
    openai |> Http.post(ep_url(batch_id, "cancel"))
  end

  @doc """
  Lists your organization's batches.

  https://platform.openai.com/docs/api-reference/batch/list
  """
  def list!(openai = %OpenaiEx{}, opts \\ []) do
    openai |> list(opts) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, opts \\ []) do
    params = opts |> Enum.into(%{}) |> Map.take([:after, :limit])
    openai |> Http.get(ep_url(), params)
  end
end
