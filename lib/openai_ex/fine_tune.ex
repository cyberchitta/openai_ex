defmodule OpenaiEx.FineTune do
  @moduledoc """
  This module provides an implementation of the OpenAI fine-tune API. The API reference can be found at https://platform.openai.com/docs/api-reference/fine-tunes.

  ## API Fields

  The following fields can be used as parameters for various endpoints of the API:

  - `:training_file`
  - `:validation_file`
  - `:model`
  - `:n_epochs`
  - `:batch_size`
  - `:learning_rate_multiplier`
  - `:prompt_loss_weight`
  - `:compute_classification_metrics`
  - `:classification_n_classes`
  - `:classification_positive_class`
  - `:classification_betas`
  - `:suffix`
  - `:stream`
  """
  @api_fields [
    :training_file,
    :validation_file,
    :model,
    :n_epochs,
    :batch_size,
    :learning_rate_multiplier,
    :prompt_loss_weight,
    :compute_classification_metrics,
    :classification_n_classes,
    :classification_positive_class,
    :classification_betas,
    :suffix,
    :stream
  ]

  @doc """
  Creates a new fine-tune request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the fine-tune request.

  ## Returns

  A map containing the fields of the fine-tune request.
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{}) do
    %{}
    |> Map.merge(args)
    |> Map.take(@api_fields)
  end

  @doc """
  Calls the fine-tune creation endpoint.

  https://platform.openai.com/docs/api-reference/fine-tunes/create
  """
  def create(openai = %OpenaiEx{}, finetune = %{}) do
    openai |> OpenaiEx.Http.post("/fine-tunes", json: finetune)
  end

  @doc """
  Calls the fine-tune list endpoint.

  https://platform.openai.com/docs/api-reference/fine-tunes/list
  """
  def list(openai = %OpenaiEx{}) do
    openai |> OpenaiEx.Http.get("/fine-tunes")
  end

  @doc """
  Calls the fine-tune retrieve endpoint.

  https://platform.openai.com/docs/api-reference/fine-tunes/retrieve
  """
  def retrieve(openai = %OpenaiEx{}, fine_tune_id: fine_tune_id) do
    openai |> OpenaiEx.Http.get("/fine-tunes/#{fine_tune_id}")
  end

  @doc """
  Calls the fine-tune cancel endpoint.

  https://platform.openai.com/docs/api-reference/fine-tunes/cancel
  """
  def cancel(openai = %OpenaiEx{}, fine_tune_id: fine_tune_id) do
    openai |> OpenaiEx.Http.post("/fine-tunes/#{fine_tune_id}/cancel", json: %{})
  end

  @doc """
  Calls the fine-tune list events endpoint.

  https://platform.openai.com/docs/api-reference/fine-tunes/events
  """
  def list_events(openai = %OpenaiEx{}, fine_tune_id: fine_tune_id) do
    openai |> OpenaiEx.Http.get("/fine-tunes/#{fine_tune_id}/events")
  end
end
