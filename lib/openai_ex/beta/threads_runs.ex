defmodule OpenaiEx.Beta.Threads.Runs do
  @moduledoc """
  This module provides an implementation of the OpenAI run API. The API
  reference can be found at https://platform.openai.com/docs/api-reference/runs.

  ## API Fields

  The following fields can be used as parameters for the messages API:

  - `:assistant_id`
  - `:model`
  - `:instructions`
  - `:tools`
  - `:metadata`
  """
  @api_fields [
    :assistant_id,
    :model,
    :instructions,
    :additional_instructions,
    :additional_messages,
    :tools,
    :metadata,
    :temperature,
    :top_p,
    :max_prompt_tokens,
    :max_completion_tokens,
    :truncation_strategy,
    :tool_choice,
    :response_format
  ]

  defp ep_url(thread_id, run_id \\ nil, action \\ nil) do
    "/threads/#{thread_id}/runs" <>
      if(is_nil(run_id), do: "", else: "/#{run_id}") <>
      if(is_nil(action), do: "", else: "/#{action}")
  end

  @doc """
  Creates a new run request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the run request.

  ## Returns

  A map containing the fields of the run request.

  The `:thread_id` and `:assistant_id` fields are required.

  Example usage:

      iex> _request = OpenaiEx.Beta.Threads.Runs.new(thread_id: "thread_foo", assistant_id: "assistant_bar")
      %{assistant_id: "assistant_bar", thread_id: "thread_foo"}
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{thread_id: _}) do
    args |> Map.take([:thread_id | @api_fields])
  end

  @doc """
  Calls the run create endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `run`: The run request, as a map with keys corresponding to the API fields.

  ## Returns

  A map containing the API response.

  See https://platform.openai.com/docs/api-reference/runs/createRun for more information.
  """
  def create(openai = %OpenaiEx{}, run = %{thread_id: thread_id, assistant_id: _}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.post(ep_url(thread_id), json: run |> Map.take(@api_fields))
  end

  @doc """
  Calls the run retrieve endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `params`: Specification of the run to retrieve.

  ## Returns

  A map containing the fields of the run retrieve response.

  https://platform.openai.com/docs/api-reference/runs/getRun
  """
  def retrieve(openai = %OpenaiEx{}, %{thread_id: thread_id, run_id: run_id}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(ep_url(thread_id, run_id))
  end

  @doc """
  Calls the run update endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `params`: run to update and new field values.

  ## Returns

  A map containing the API response.

  See https://platform.openai.com/docs/api-reference/assistants/modifyAssistant for more information.
  """
  def update(openai = %OpenaiEx{}, %{thread_id: thread_id, run_id: run_id, metadata: metadata}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.post(ep_url(thread_id, run_id), json: %{metadata: metadata})
  end

  @doc """
  Creates a new list runs request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the list runs request.

  ## Returns

  A map containing the fields of the list runs request.
  """

  def new_list(args = [_ | _]) do
    args |> Enum.into(%{}) |> new_list()
  end

  def new_list(args = %{}) do
    args
    |> Map.take(OpenaiEx.list_query_fields())
  end

  @doc """
  Returns a list of runs objects.

  https://platform.openai.com/docs/api-reference/runs/listRuns
  """
  def list(openai = %OpenaiEx{}, thread_id, params = %{} \\ %{}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.get(ep_url(thread_id), params |> Map.take(OpenaiEx.list_query_fields()))
  end

  def submit_tool_outputs(
        openai = %OpenaiEx{},
        %{thread_id: thread_id, run_id: run_id, tool_outputs: tool_outputs}
      ) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.post(
      ep_url(thread_id, run_id, "submit_tool_outputs"),
      json: %{tool_outputs: tool_outputs}
    )
  end

  def cancel(openai = %OpenaiEx{}, %{thread_id: thread_id, run_id: run_id}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.post(ep_url(thread_id, run_id, "cancel"))
  end

  @car_fields [
    :assistant_id,
    :thread,
    :model,
    :instructions,
    :tools,
    :tool_resources,
    :metadata,
    :temperature,
    :top_p,
    :max_prompt_tokens,
    :max_completion_tokens,
    :truncation_strategy,
    :tool_choice,
    :response_format
  ]

  def create_and_run(openai = %OpenaiEx{}, params = %{assistant_id: _}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> OpenaiEx.Http.post("/threads/runs", json: params |> Map.take(@car_fields))
  end
end
