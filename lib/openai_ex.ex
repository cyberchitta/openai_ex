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

  def middleware(openai = %OpenaiEx{}) do
    mw = [
      {Tesla.Middleware.BaseUrl, "https://api.openai.com/v1"}
    ]

    headers = [{"Authorization", "Bearer #{openai.token}"}]

    if is_nil(openai.organization) do
      mw ++ [{Tesla.Middleware.Headers, headers}]
    else
      mw ++
        [{Tesla.Middleware.Headers, headers ++ [{"OpenAI-Organization", openai.organization}]}]
    end
  end

  @doc """
  Sends a POST request to the specified OpenAI API URL endpoint with the specified body encoded as JSON or multipart/form-data.
  """
  def post(openai = %OpenaiEx{}, url, json: json) do
    (middleware(openai) ++ [Tesla.Middleware.JSON])
    |> Tesla.client()
    |> Tesla.post!(url, json)
    |> Map.get(:body)
  end

  def post(openai = %OpenaiEx{}, url, multipart: multipart) do
    (middleware(openai) ++ [Tesla.Middleware.DecodeJson])
    |> Tesla.client()
    |> Tesla.post!(url, multipart)
    |> Map.get(:body)
  end

  @doc """
  Sends a GET request to the specified OpenAI API URL endpoint.
  """
  def get(openai = %OpenaiEx{}, url) do
    (middleware(openai) ++ [Tesla.Middleware.JSON])
    |> Tesla.client()
    |> Tesla.get!(url)
    |> Map.get(:body)
  end
end
