defmodule OpenaiEx.FineTuning.Job do
  @moduledoc """
  This module provides an implementation of the OpenAI fine-tuning job API. The API reference can be found at https://platform.openai.com/docs/api-reference/fine-tuning.

  ## API Fields

  The following fields can be used as parameters for various endpoints of the API:

  - `:model`
  - `:training_file`
  - `:hyperparameters`
  - `:suffix`
  - `:validation_file`

  - `:after`
  - `:limit`
  """
  @api_fields [
    :model,
    :hyperparameters,
    :suffix,
    :training_file,
    :validation_file,
    :after,
    :limit
  ]

  defp ep_url(fine_tuning_job_id \\ nil, action \\ nil) do
    "/fine_tuning/jobs" <>
      if(is_nil(fine_tuning_job_id), do: "", else: "/#{fine_tuning_job_id}") <>
      if(is_nil(action), do: "", else: "/#{action}")
  end

  @doc """
  Creates a new fine-tuning job request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the fine-tuning job request.

  ## Returns

  A map containing the fields of the fine-tuning job request.
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{}) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Calls the fine-tuning job creation endpoint.

  https://platform.openai.com/docs/api-reference/fine-tuning/create
  """
  def create(openai = %OpenaiEx{}, finetuning = %{}) do
    openai |> OpenaiEx.Http.post(ep_url(), json: finetuning)
  end

  @doc """
  Calls the fine-tuning job list endpoint.

  https://platform.openai.com/docs/api-reference/fine-tuning/list
  """
  def list(openai = %OpenaiEx{}, params = %{} \\ %{}) do
    openai |> OpenaiEx.Http.get(ep_url(), params |> Map.take(@api_fields))
  end

  @doc """
  Calls the fine-tuning job retrieve endpoint.

  https://platform.openai.com/docs/api-reference/fine-tuning/retrieve
  """
  def retrieve(openai = %OpenaiEx{}, fine_tuning_job_id: fine_tuning_job_id) do
    openai |> OpenaiEx.Http.get(ep_url(fine_tuning_job_id))
  end

  @doc """
  Calls the fine-tuning job cancel endpoint.

  https://platform.openai.com/docs/api-reference/fine-tuning/cancel
  """
  def cancel(openai = %OpenaiEx{}, fine_tuning_job_id: fine_tuning_job_id) do
    openai |> OpenaiEx.Http.post(ep_url(fine_tuning_job_id, "cancel"))
  end

  @doc """
  Calls the fine-tuning job list events endpoint.

  https://platform.openai.com/docs/api-reference/fine-tuning/events
  """
  def list_events(openai = %OpenaiEx{}, fine_tuning_job_id: fine_tuning_job_id) do
    openai |> OpenaiEx.Http.get(ep_url(fine_tuning_job_id, "events"))
  end
end
