defmodule OpenaiEx.Beta.Threads.Runs do
  @moduledoc """
  This module provides an implementation of the OpenAI run API. The API
  reference can be found at https://platform.openai.com/docs/api-reference/runs.
  """
  alias OpenaiEx.{Http, HttpSse}

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
  @query_params [
    :include
  ]

  @ep_url "/threads/runs"

  defp ep_url(thread_id, run_id \\ nil, action \\ nil) do
    "/threads/#{thread_id}/runs" <>
      if(is_nil(run_id), do: "", else: "/#{run_id}") <>
      if(is_nil(action), do: "", else: "/#{action}")
  end

  @doc """
  Creates a new run request

  Example usage:

      iex> _request = OpenaiEx.Beta.Threads.Runs.new(thread_id: "thread_foo", assistant_id: "assistant_bar")
      %{assistant_id: "assistant_bar", thread_id: "thread_foo"}
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{thread_id: _}) do
    args |> Map.take([:thread_id] ++ @api_fields ++ @query_params)
  end

  @doc """
  Calls the run create endpoint.

  See https://platform.openai.com/docs/api-reference/runs/createRun for more information.
  """
  def create!(openai = %OpenaiEx{}, run = %{thread_id: _, assistant_id: _}, stream: true) do
    openai |> create(run, stream: true) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, run = %{thread_id: thread_id, assistant_id: _}, stream: true) do
    json = run |> Map.take(@api_fields) |> Map.put(:stream, true)
    url = Http.build_url(ep_url(thread_id), run |> Map.take(@query_params))
    openai |> OpenaiEx.with_assistants_beta() |> HttpSse.post(url, json: json)
  end

  def create!(openai = %OpenaiEx{}, run = %{thread_id: _, assistant_id: _}) do
    openai |> create(run) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, run = %{thread_id: thread_id, assistant_id: _}) do
    json = run |> Map.take(@api_fields)
    url = Http.build_url(ep_url(thread_id), run |> Map.take(@query_params))
    openai |> OpenaiEx.with_assistants_beta() |> Http.post(url, json: json)
  end

  @doc """
  Calls the run retrieve endpoint.

  https://platform.openai.com/docs/api-reference/runs/getRun
  """
  def retrieve!(openai = %OpenaiEx{}, params = %{thread_id: _, run_id: _}) do
    openai |> retrieve(params) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, %{thread_id: thread_id, run_id: run_id}) do
    openai |> OpenaiEx.with_assistants_beta() |> Http.get(ep_url(thread_id, run_id))
  end

  @doc """
  Calls the run update endpoint.

  See https://platform.openai.com/docs/api-reference/assistants/modifyAssistant for more information.
  """
  def update!(openai = %OpenaiEx{}, params = %{thread_id: _, run_id: _, metadata: _}) do
    openai |> update(params) |> Http.bang_it!()
  end

  def update(openai = %OpenaiEx{}, %{thread_id: thread_id, run_id: run_id, metadata: metadata}) do
    json = %{metadata: metadata}
    openai |> OpenaiEx.with_assistants_beta() |> Http.post(ep_url(thread_id, run_id), json: json)
  end

  @doc """
  Creates a new list runs request
  """

  def new_list(args = [_ | _]) do
    args |> Enum.into(%{}) |> new_list()
  end

  def new_list(args = %{}) do
    args
    |> Map.take(OpenaiEx.list_query_fields() ++ @query_params)
  end

  @doc """
  Returns a list of runs objects.

  https://platform.openai.com/docs/api-reference/runs/listRuns
  """
  def list!(openai = %OpenaiEx{}, opts) when is_list(opts) do
    openai |> list(opts) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, opts) when is_list(opts) do
    thread_id = Keyword.fetch!(opts, :thread_id)

    params =
      opts
      |> Keyword.drop([:thread_id])
      |> Enum.into(%{})
      |> Map.take(OpenaiEx.list_query_fields() ++ @query_params)

    openai |> OpenaiEx.with_assistants_beta() |> Http.get(ep_url(thread_id), params)
  end

  def submit_tool_outputs!(
        openai = %OpenaiEx{},
        params = %{thread_id: _, run_id: _, tool_outputs: _},
        stream: true
      ) do
    openai |> submit_tool_outputs(params, stream: true) |> Http.bang_it!()
  end

  def submit_tool_outputs(
        openai = %OpenaiEx{},
        %{thread_id: thread_id, run_id: run_id, tool_outputs: tool_outputs},
        stream: true
      ) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> HttpSse.post(
      ep_url(thread_id, run_id, "submit_tool_outputs"),
      json: %{tool_outputs: tool_outputs} |> Map.put(:stream, true)
    )
  end

  def submit_tool_outputs!(
        openai = %OpenaiEx{},
        params = %{thread_id: _, run_id: _, tool_outputs: _}
      ) do
    openai |> submit_tool_outputs(params) |> Http.bang_it!()
  end

  def submit_tool_outputs(
        openai = %OpenaiEx{},
        %{thread_id: thread_id, run_id: run_id, tool_outputs: tool_outputs}
      ) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> Http.post(
      ep_url(thread_id, run_id, "submit_tool_outputs"),
      json: %{tool_outputs: tool_outputs}
    )
  end

  def cancel!(openai = %OpenaiEx{}, params = %{thread_id: _, run_id: _}) do
    openai |> cancel(params) |> Http.bang_it!()
  end

  def cancel(openai = %OpenaiEx{}, %{thread_id: thread_id, run_id: run_id}) do
    openai |> OpenaiEx.with_assistants_beta() |> Http.post(ep_url(thread_id, run_id, "cancel"))
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

  def create_and_run!(openai = %OpenaiEx{}, params = %{assistant_id: _}, stream: true) do
    openai |> create_and_run(params, stream: true) |> Http.bang_it!()
  end

  def create_and_run(openai = %OpenaiEx{}, params = %{assistant_id: _}, stream: true) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> HttpSse.post(@ep_url,
      json: params |> Map.take(@car_fields) |> Map.put(:stream, true)
    )
  end

  def create_and_run!(openai = %OpenaiEx{}, params = %{assistant_id: _}) do
    openai |> create_and_run(params) |> Http.bang_it!()
  end

  def create_and_run(openai = %OpenaiEx{}, params = %{assistant_id: _}) do
    openai
    |> OpenaiEx.with_assistants_beta()
    |> Http.post(@ep_url, json: params |> Map.take(@car_fields))
  end
end
