defmodule OpenaiEx.Model do
  @moduledoc """
  This module provides an implementation of the OpenAI Models API. Information about these models can be found at https://beta.openai.com/docs/models.
  """

  @doc """
  Lists the available models.

  https://beta.openai.com/docs/api-reference/models/list
  """
  def list(openai = %OpenaiEx{}) do
    openai |> OpenaiEx.get("/models") |> Map.get("data")
  end

  @doc """
  Retrieves a specific model by ID.

  https://beta.openai.com/docs/api-reference/models/retrieve
  """
  def retrieve(openai = %OpenaiEx{}, model_id) do
    openai |> OpenaiEx.get("/models/#{model_id}")
  end
end
