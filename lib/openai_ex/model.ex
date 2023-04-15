defmodule OpenaiEx.Model do
  @moduledoc """
  https://platform.openai.com/docs/api-reference/models
  """

  @doc """
  https://platform.openai.com/docs/api-reference/models/list
  """
  def list(openai = %OpenaiEx{}) do
    openai
    |> OpenaiEx.req()
    |> Req.get!(url: "/models")
    |> Map.get(:body)
    |> Map.get("data")
  end

  @doc """
  https://platform.openai.com/docs/api-reference/models/retrieve
  """
  def retrieve(openai = %OpenaiEx{}, model_id) do
    openai
    |> OpenaiEx.req()
    |> Req.get!(url: "/models/#{model_id}")
    |> Map.get(:body)
  end
end
