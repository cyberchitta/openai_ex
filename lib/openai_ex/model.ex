defmodule OpenaiEx.Model do
  @moduledoc """
  This module provides an implementation of the OpenAI Models API. Information about these models can be found at https://platform.openai.com/docs/models.
  """

  @doc """
  Lists the available models.

  https://platform.openai.com/docs/api-reference/models/list
  """
  def list(openai = %OpenaiEx{}) do
    openai |> OpenaiEx.get("/models")
  end

  @doc """
  Retrieves a specific model.

  https://platform.openai.com/docs/api-reference/models/retrieve
  """
  def retrieve(openai = %OpenaiEx{}, model) do
    openai |> OpenaiEx.get("/models/#{model}")
  end

  @doc """
  Deletes a specific model.

  https://platform.openai.com/docs/api-reference/fine-tunes/delete-model
  """
  def delete(openai = %OpenaiEx{}, model) do
    openai |> OpenaiEx.delete("/models/#{model}")
  end
end
