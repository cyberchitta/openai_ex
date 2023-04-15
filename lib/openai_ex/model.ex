defmodule OpenaiEx.Model do
  @moduledoc """
  https://platform.openai.com/docs/api-reference/models
  """

  @doc """
  https://platform.openai.com/docs/api-reference/models/list
  """
  def list(openai = %OpenaiEx{}) do
    openai |> OpenaiEx.get("/models") |> Map.get("data")
  end

  @doc """
  https://platform.openai.com/docs/api-reference/models/retrieve
  """
  def retrieve(openai = %OpenaiEx{}, model_id) do
    openai |> OpenaiEx.get("/models/#{model_id}")
  end
end
