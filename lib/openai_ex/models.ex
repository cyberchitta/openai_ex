defmodule OpenaiEx.Models do
  def list(openai = %OpenaiEx{}) do
    openai
    |> OpenaiEx.req()
    |> Req.get!(url: "/models")
    |> Map.get(:body)
    |> Map.get("data")
  end

  def model(openai = %OpenaiEx{}, model_id) do
    openai
    |> OpenaiEx.req()
    |> Req.get!(url: "/models/#{model_id}")
    |> Map.get(:body)
  end
end
