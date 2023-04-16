defmodule OpenaiEx do
  @moduledoc """
  `OpenaiEx` is an Elixir library that provides a community-maintained client for the OpenAI API.

  The library closely follows the structure of the [official OpenAI API client libraries](https://platform.openai.com/docs/api-reference)
  for [Python](https://github.com/openai/openai-python)
  and [JavaScript](https://github.com/openai/openai-node),
  making it easy to understand and reuse existing documentation and code.
  """
  @enforce_keys [:token]
  defstruct token: nil, organization: nil

  @doc """
  Creates a new OpenaiEx struct with the specified token and organization.

  See https://platform.openai.com/docs/api-reference/authentication for details.
  """
  def new(token, organization \\ nil) do
    %OpenaiEx{
      token: token,
      organization: organization
    }
  end

  defp req(openai = %OpenaiEx{}) do
    options = [base_url: "https://api.openai.com/v1", auth: {:bearer, openai.token}]

    if is_nil(openai.organization) do
      options
    else
      options ++ [headers: ["OpenAI-Organization", openai.organization]]
    end
    |> Req.new()
  end

  @doc """
  Sends a POST request to the specified OpenAI API URL endpoint with the specified JSON body.
  """
  def post(openai = %OpenaiEx{}, url, json) do
    openai
    |> req()
    |> Req.post!(url: url, json: json)
    |> Map.get(:body)
  end

  @doc """
  Sends a GET request to the specified OpenAI API URL endpoint.
  """
  def get(openai = %OpenaiEx{}, url) do
    openai
    |> req()
    |> Req.get!(url: url)
    |> Map.get(:body)
  end
end
