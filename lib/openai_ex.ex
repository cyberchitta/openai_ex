defmodule OpenaiEx do
  @moduledoc """
  `OpenaiEx` is an Elixir library that provides a community-maintained client for the OpenAI API.

  The library closely follows the structure of the [official OpenAI API client libraries](https://platform.openai.com/docs/api-reference)
  for [Python](https://github.com/openai/openai-python)
  and [JavaScript](https://github.com/openai/openai-node),
  making it easy to understand and reuse existing documentation and code.
  """
  @enforce_keys [:token]
  defstruct token: nil,
            organization: nil,
            beta: nil,
            base_url: "https://api.openai.com/v1",
            receive_timeout: 120_000

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

  # Globals for internal library use, **not** for public use.

  @doc false
  def with_assistants_beta(openai = %OpenaiEx{}) do
    openai |> Map.put(:beta, "assistants=v1")
  end

  def with_base_url(openai = %OpenaiEx{}, base_url) do
    openai |> Map.put(:base_url, base_url)
  end

  def with_receive_timeout(openai = %OpenaiEx{}, receive_timeout) do
    openai |> Map.put(:receive_timeout, receive_timeout)
  end

  @doc false
  def list_query_fields() do
    [
      :after,
      :before,
      :limit,
      :order
    ]
  end
end
