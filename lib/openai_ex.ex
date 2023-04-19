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

  @doc false
  def middleware(openai = %OpenaiEx{}) do
    mw = [{Tesla.Middleware.BaseUrl, "https://api.openai.com/v1"}]

    headers = [{"Authorization", "Bearer #{openai.token}"}]

    if is_nil(openai.organization) do
      mw ++ [{Tesla.Middleware.Headers, headers}]
    else
      mw ++
        [{Tesla.Middleware.Headers, headers ++ [{"OpenAI-Organization", openai.organization}]}]
    end
  end

  @doc false
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

  @doc false
  def get(openai = %OpenaiEx{}, url) do
    (middleware(openai) ++ [Tesla.Middleware.JSON])
    |> Tesla.client()
    |> Tesla.get!(url)
    |> Map.get(:body)
  end

  @doc false
  def to_multi_part_form_data(req, file_keys) do
    mp =
      req
      |> Map.drop(file_keys)
      |> Enum.reduce(Tesla.Multipart.new(), fn {k, v}, acc ->
        acc |> Tesla.Multipart.add_field(to_string(k), v)
      end)

    req
    |> Map.take(file_keys)
    |> Enum.reduce(mp, fn {k, v}, acc ->
      {filename, content} =
        case v do
          {f, c} -> {f, c}
          c -> {"", c}
        end

      acc |> Tesla.Multipart.add_file_content(content, filename, name: to_string(k))
    end)
  end

  @doc """
  OpenAI API has endpoints which need a file parameter, such as Files and Audio.
  This function creates a file parameter given a name and content or a local file path.
  """
  def new_file(name: name, content: content) do
    {name, content}
  end

  def new_file(path: path) do
    {path, File.read!(path)}
  end
end
