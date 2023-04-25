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

  @base_url "https://api.openai.com/v1"

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
  def headers(openai = %OpenaiEx{}) do
    headers = [{"Authorization", "Bearer #{openai.token}"}]

    if is_nil(openai.organization) do
      headers
    else
      headers ++ [{"OpenAI-Organization", openai.organization}]
    end
  end

  @doc false
  def post(openai = %OpenaiEx{}, url, multipart: multipart) do
    body_stream = Multipart.body_stream(multipart)
    content_length = Multipart.content_length(multipart)
    content_type = Multipart.content_type(multipart, "multipart/form-data")

    :post
    |> Finch.build(
      @base_url <> url,
      headers(openai) ++
        [{"Content-Type", content_type}, {"Content-Length", to_string(content_length)}],
      {:stream, body_stream}
    )
    |> finch_run()
  end

  @doc false
  def post(openai = %OpenaiEx{}, url, json: json) do
    :post
    |> Finch.build(
      @base_url <> url,
      headers(openai) ++ [{"Content-Type", "application/json"}],
      Jason.encode_to_iodata!(json)
    )
    |> finch_run()
  end

  @doc false
  def get(openai = %OpenaiEx{}, url) do
    :get
    |> Finch.build(@base_url <> url, headers(openai))
    |> finch_run()
  end

  @doc false
  def delete(openai = %OpenaiEx{}, url) do
    :delete
    |> Finch.build(@base_url <> url, headers(openai))
    |> finch_run()
  end

  @doc false
  def finch_run(finch_request) do
    finch_request
    |> Finch.request!(OpenaiEx.Finch)
    |> Map.get(:body)
    |> Jason.decode!()
  end

  @doc false
  def to_multi_part_form_data(req, file_fields) do
    mp =
      req
      |> Map.drop(file_fields)
      |> Enum.reduce(Multipart.new(), fn {k, v}, acc ->
        acc |> Multipart.add_part(Multipart.Part.text_field(v, k))
      end)

    req
    |> Map.take(file_fields)
    |> Enum.reduce(mp, fn {k, v}, acc ->
      {filename, content} =
        case v do
          {f, c} -> {f, c}
          c -> {"", c}
        end

      acc
      |> Multipart.add_part(
        Multipart.Part.file_content_field(filename, content, k, filename: filename)
      )
    end)
  end

  @doc """
  Create file parameter struct for use in multipart requests.

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
