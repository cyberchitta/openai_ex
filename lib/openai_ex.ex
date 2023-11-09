defmodule OpenaiEx do
  @moduledoc """
  `OpenaiEx` is an Elixir library that provides a community-maintained client for the OpenAI API.

  The library closely follows the structure of the [official OpenAI API client libraries](https://platform.openai.com/docs/api-reference)
  for [Python](https://github.com/openai/openai-python)
  and [JavaScript](https://github.com/openai/openai-node),
  making it easy to understand and reuse existing documentation and code.
  """
  @enforce_keys [:token]
  defstruct token: nil, organization: nil, beta: nil

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

  @doc """
  Create file parameter struct for use in multipart requests.

  OpenAI API has endpoints which need a file parameter, such as Files and Audio.
  This function creates a file parameter given a name (optional) and content or a local file path.
  """
  def new_file(name: name, content: content) do
    {name, content}
  end

  def new_file(path: path) do
    {path}
  end

  # Global constants used in the library

  def assistants_beta_string() do
    "assistants=v1"
  end

  def list_query_fields() do
    [
      :after,
      :before,
      :limit,
      :order
    ]
  end
end
