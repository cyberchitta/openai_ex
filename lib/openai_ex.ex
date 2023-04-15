defmodule OpenaiEx do
  @moduledoc """
  https://platform.openai.com/docs/api-reference/authentication
  """
  @enforce_keys [:token]
  defstruct token: nil, organization: nil

  def new(token, organization \\ nil) do
    %OpenaiEx{
      token: token,
      organization: organization
    }
  end

  def req(openai = %OpenaiEx{}) do
    options = [base_url: "https://api.openai.com/v1", auth: {:bearer, openai.token}]

    if is_nil(openai.organization) do
      options
    else
      options ++ [headers: ["OpenAI-Organization", openai.organization]]
    end
    |> Req.new()
  end

  def post(openai = %OpenaiEx{}, url, json) do
    openai
    |> req()
    |> Req.post!(url: url, json: json)
    |> Map.get(:body)
  end

  def get(openai = %OpenaiEx{}, url) do
    openai
    |> req()
    |> Req.get!(url: url)
    |> Map.get(:body)
  end
end
