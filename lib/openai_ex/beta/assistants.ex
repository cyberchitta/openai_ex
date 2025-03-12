defmodule OpenaiEx.Beta.Assistants do
  @moduledoc """
  This module provides an implementation of the OpenAI assistants API. The API reference can be found at https://platform.openai.com/docs/api-reference/assistants.
  """
  alias OpenaiEx.Http

  @api_fields [
    :model,
    :name,
    :description,
    :instructions,
    :tools,
    :tool_resources,
    :metadata,
    :temperature,
    :top_p,
    :response_format
  ]

  defp ep_url(assistant_id \\ nil) do
    "/assistants" <> if is_nil(assistant_id), do: "", else: "/#{assistant_id}"
  end

  @doc """
  Creates a new assistants request

  Example usage:

      iex> _request = OpenaiEx.Beta.Assistants.new(model: "gpt-4-turbo")
      %{model: "gpt-4-turbo"}
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{model: model}) do
    %{
      model: model
    }
    |> Map.merge(args)
    |> Map.take(@api_fields)
  end

  @doc """
  Calls the assistant 'create' endpoint.

  See https://platform.openai.com/docs/api-reference/assistants/createAssistant for more information.
  """
  def create!(openai = %OpenaiEx{}, assistant = %{}) do
    openai |> create(assistant) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, assistant = %{}) do
    json = assistant |> Map.take(@api_fields)
    openai |> OpenaiEx.with_assistants_beta() |> Http.post(ep_url(), json: json)
  end

  @doc """
  Calls the assistant retrieve endpoint.

  https://platform.openai.com/docs/api-reference/assistants/getAssistant
  """
  def retrieve!(openai = %OpenaiEx{}, assistant_id) do
    openai |> retrieve(assistant_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, assistant_id) do
    openai |> OpenaiEx.with_assistants_beta() |> Http.get(ep_url(assistant_id))
  end

  @doc """
  Calls the assistant update endpoint.

  See https://platform.openai.com/docs/api-reference/assistants/modifyAssistant for more information.
  """
  def update!(openai = %OpenaiEx{}, assistant_id, assistant = %{}) do
    openai |> update(assistant_id, assistant) |> Http.bang_it!()
  end

  def update(openai = %OpenaiEx{}, assistant_id, assistant = %{}) do
    json = assistant |> Map.take(@api_fields)
    openai |> OpenaiEx.with_assistants_beta() |> Http.post(ep_url(assistant_id), json: json)
  end

  @doc """
  Calls the assistant delete endpoint.

  https://platform.openai.com/docs/api-reference/assistants/deleteAssistant
  """
  def delete!(openai = %OpenaiEx{}, assistant_id) do
    openai |> delete(assistant_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, assistant_id) do
    openai |> OpenaiEx.with_assistants_beta() |> Http.delete(ep_url(assistant_id))
  end

  @doc """
  Creates a new list assistants request
  """

  def new_list(args = [_ | _]) do
    args |> Enum.into(%{}) |> new_list()
  end

  def new_list(args = %{}) do
    args |> Map.take(OpenaiEx.list_query_fields())
  end

  @doc """
  Returns a list of assistant objects.

  https://platform.openai.com/docs/api-reference/assistants/listAssistants
  """
  def list!(openai = %OpenaiEx{}, params = %{} \\ %{}) do
    openai |> list(params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, params = %{} \\ %{}) do
    qry_params = params |> Map.take(OpenaiEx.list_query_fields())
    openai |> OpenaiEx.with_assistants_beta() |> Http.get(ep_url(), qry_params)
  end
end
