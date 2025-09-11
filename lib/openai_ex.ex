defmodule OpenaiEx do
  @moduledoc """
  `OpenaiEx` is an Elixir library that provides a community-maintained client for
  the OpenAI API.

  The library closely follows the structure of the [official OpenAI API client libraries](https://platform.openai.com/docs/api-reference)
  for [Python](https://github.com/openai/openai-python) making it easy to understand
  and reuse existing documentation and code.
  """
  defstruct token: nil,
            organization: nil,
            project: nil,
            beta: nil,
            base_url: "https://api.openai.com/v1",
            receive_timeout: 15_000,
            stream_timeout: :infinity,
            finch_name: OpenaiEx.Finch,
            _ep_path_mapping: &OpenaiEx._identity/1,
            _http_headers: nil

  @doc """
  Creates a new OpenaiEx struct with the specified token and organization.

  See https://platform.openai.com/docs/api-reference/authentication for details.
  """
  def new(token, organization \\ nil, project \\ nil) do
    headers =
      [{"Authorization", "Bearer #{token}"}] ++
        if(is_nil(organization),
          do: [],
          else: [{"OpenAI-Organization", organization}]
        ) ++
        if(is_nil(project),
          do: [],
          else: [{"OpenAI-Project", project}]
        )

    %OpenaiEx{
      token: token,
      organization: organization,
      project: project,
      _http_headers: headers
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

  @assistants_beta_string "assistants=v2"
  @doc false
  def with_assistants_beta(openai = %OpenaiEx{}) do
    openai
    |> Map.put(:beta, @assistants_beta_string)
    |> Map.get_and_update(:_http_headers, fn headers ->
      {headers, headers ++ [{"OpenAI-Beta", @assistants_beta_string}]}
    end)
    |> elem(1)
  end

  # Globals to allow slight changes to API
  # Not public, and with no guarantee that they will continue to be supported.

  @doc false
  def _identity(x), do: x

  @doc false
  def _with_ep_path_mapping(openai = %OpenaiEx{}, ep_path_mapping) do
    openai |> Map.put(:_ep_path_mapping, ep_path_mapping)
  end

  # https://learn.microsoft.com/en-us/azure/ai-services/openai/reference
  @doc false
  def _azure_ep_path_mapping(api_version) do
    fn ep ->
      case ep do
        "/chat/completions" -> "/chat/completions?api-version=#{api_version}"
        "/completions" -> "/completions?api-version=#{api_version}"
        "/embeddings" -> "/embeddings?api-version=#{api_version}"
        _ -> ep
      end
    end
  end

  # Azure OpenAI. Not public and with no guarantee of continued support.
  def _for_azure(openai = %OpenaiEx{}, resource_name, deployment_id, api_version) do
    openai
    |> with_base_url("https://#{resource_name}.openai.azure.com/openai/deployments/#{deployment_id}")
    |> _with_ep_path_mapping(_azure_ep_path_mapping(api_version))
  end

  def _for_azure(azure_api_key, resource_name, deployment_id, api_version) do
    %OpenaiEx{
      _http_headers: [{"api-key", "#{azure_api_key}"}]
    }
    |> _for_azure(resource_name, deployment_id, api_version)
  end

  # Globals for public use.

  def with_base_url(openai = %OpenaiEx{}, base_url) do
    openai |> Map.put(:base_url, base_url)
  end

  def with_additional_headers(openai = %OpenaiEx{}, additional_headers) do
    Map.update(openai, :_http_headers, [], fn existing_headers ->
      existing_headers ++ Enum.to_list(additional_headers)
    end)
  end

  def with_receive_timeout(openai = %OpenaiEx{}, timeout)
      when is_integer(timeout) and timeout > 0 do
    openai |> Map.put(:receive_timeout, timeout)
  end

  def with_stream_timeout(openai = %OpenaiEx{}, timeout)
      when is_integer(timeout) and timeout > 0 do
    openai |> Map.put(:stream_timeout, timeout)
  end

  def with_finch_name(openai = %OpenaiEx{}, finch_name) do
    openai |> Map.put(:finch_name, finch_name)
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
