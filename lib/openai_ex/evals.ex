defmodule OpenaiEx.Evals do
  @moduledoc """
  This module provides an implementation of the OpenAI evals API. The API reference can be found at https://platform.openai.com/docs/api-reference/evals.
  """
  alias OpenaiEx.Http

  @api_fields [
    :data_source_config,
    :testing_criteria,
    :metadata,
    :name
  ]

  @run_api_fields [
    :data_source,
    :metadata,
    :name
  ]

  defp ep_url(eval_id \\ nil, action \\ nil, run_id \\ nil, output_item_id \\ nil) do
    base =
      "/evals" <>
        if(is_nil(eval_id), do: "", else: "/#{eval_id}") <>
        if(is_nil(action), do: "", else: "/#{action}")

    case {run_id, output_item_id} do
      {nil, nil} -> base
      {run_id, nil} -> base <> "/#{run_id}"
      {run_id, output_item_id} -> base <> "/#{run_id}/output_items/#{output_item_id}"
    end
  end

  @doc """
  Creates a new eval request

  See https://platform.openai.com/docs/api-reference/evals/create for full list of request parameters.

  Example usage:

      iex> _request = OpenaiEx.Evals.new(name: "Sentiment")
      %{name: "Sentiment"}

      iex> _request = OpenaiEx.Evals.new(%{name: "Sentiment", testing_criteria: [%{type: "label_model", ...}]})
      %{name: "Sentiment", testing_criteria: [%{type: "label_model", ...}]}
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{name: name}) do
    %{
      name: name
    }
    |> Map.merge(args)
    |> Map.take(@api_fields)
  end

  @doc """
  Creates a new eval run request

  See https://platform.openai.com/docs/api-reference/evals/createRun for full list of request parameters.

  Example usage:

      iex> _request = OpenaiEx.Evals.new_run(name: "gpt-4o-mini")
      %{name: "gpt-4o-mini"}

      iex> _request = OpenaiEx.Evals.new_run(%{name: "gpt-4o-mini", data_source: %{type: "completions", ...}})
      %{name: "gpt-4o-mini", data_source: %{type: "completions", ...}}
  """
  def new_run(args = [_ | _]) do
    args |> Enum.into(%{}) |> new_run()
  end

  def new_run(args = %{name: name}) do
    %{
      name: name
    }
    |> Map.merge(args)
    |> Map.take(@run_api_fields)
  end

  @doc """
  Calls the eval 'create' endpoint.

  See https://platform.openai.com/docs/api-reference/evals/create for more information.
  """
  def create!(openai = %OpenaiEx{}, eval_request = %{}) do
    openai |> create(eval_request) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, eval_request = %{}) do
    json = eval_request |> Map.take(@api_fields)
    openai |> Http.post(ep_url(), json: json)
  end

  @doc """
  Calls the eval update endpoint.

  See https://platform.openai.com/docs/api-reference/evals/update for more information.
  """
  def update!(openai = %OpenaiEx{}, eval_id, eval_request = %{}) do
    openai |> update(eval_id, eval_request) |> Http.bang_it!()
  end

  def update(openai = %OpenaiEx{}, eval_id, eval_request = %{}) do
    json = eval_request |> Map.take(@api_fields)
    openai |> Http.post(ep_url(eval_id), json: json)
  end

  @doc """
  Calls the eval delete endpoint.

  See https://platform.openai.com/docs/api-reference/evals/delete for more information.
  """
  def delete!(openai = %OpenaiEx{}, eval_id) do
    openai |> delete(eval_id) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, eval_id) do
    openai |> Http.delete(ep_url(eval_id))
  end

  @doc """
  Lists all evals that belong to the user's organization.

  See https://platform.openai.com/docs/api-reference/evals/list for more information.
  """
  def list!(openai = %OpenaiEx{}, params \\ %{}) do
    openai |> list(params) |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}, params \\ %{}) do
    query_params = params |> Map.take(OpenaiEx.list_query_fields())
    openai |> Http.get(ep_url(), query_params)
  end

  # Run-related functions

  @doc """
  Lists all runs for a specific evaluation.

  See https://platform.openai.com/docs/api-reference/evals/getRuns for more information.
  """
  def get_runs!(openai = %OpenaiEx{}, eval_id) do
    openai |> get_runs(eval_id) |> Http.bang_it!()
  end

  def get_runs(openai = %OpenaiEx{}, eval_id) do
    openai |> Http.get(ep_url(eval_id, "runs"))
  end

  @doc """
  Retrieves a specific run for an evaluation.

  See https://platform.openai.com/docs/api-reference/evals/getRun for more information.
  """
  def get_run!(openai = %OpenaiEx{}, eval_id, run_id) do
    openai |> get_run(eval_id, run_id) |> Http.bang_it!()
  end

  def get_run(openai = %OpenaiEx{}, eval_id, run_id) do
    openai |> Http.get(ep_url(eval_id, "runs", run_id))
  end

  @doc """
  Creates a new run for an evaluation.

  See https://platform.openai.com/docs/api-reference/evals/createRun for more information.
  """
  def create_run!(openai = %OpenaiEx{}, eval_id, run_request = %{}) do
    openai |> create_run(eval_id, run_request) |> Http.bang_it!()
  end

  def create_run(openai = %OpenaiEx{}, eval_id, run_request = %{}) do
    json = run_request |> Map.take(@run_api_fields)
    openai |> Http.post(ep_url(eval_id, "runs"), json: json)
  end

  @doc """
  Cancels a specific run for an evaluation.

  See https://platform.openai.com/docs/api-reference/evals/cancelRun for more information.
  """
  def cancel_run!(openai = %OpenaiEx{}, eval_id, run_id) do
    openai |> cancel_run(eval_id, run_id) |> Http.bang_it!()
  end

  def cancel_run(openai = %OpenaiEx{}, eval_id, run_id) do
    openai |> Http.post(ep_url(eval_id, "runs", run_id, "cancel"), json: %{})
  end

  @doc """
  Deletes a specific run for an evaluation.

  See https://platform.openai.com/docs/api-reference/evals/deleteRun for more information.
  """
  def delete_run!(openai = %OpenaiEx{}, eval_id, run_id) do
    openai |> delete_run(eval_id, run_id) |> Http.bang_it!()
  end

  def delete_run(openai = %OpenaiEx{}, eval_id, run_id) do
    openai |> Http.delete(ep_url(eval_id, "runs", run_id))
  end

  # Output item-related functions

  @doc """
  Retrieves a specific output item for a run.

  See https://platform.openai.com/docs/api-reference/evals/getRunOutputItem for more information.
  """
  def get_run_output_item!(openai = %OpenaiEx{}, eval_id, run_id, output_item_id) do
    openai |> get_run_output_item(eval_id, run_id, output_item_id) |> Http.bang_it!()
  end

  def get_run_output_item(openai = %OpenaiEx{}, eval_id, run_id, output_item_id) do
    openai |> Http.get(ep_url(eval_id, "runs", run_id, output_item_id))
  end

  @doc """
  Lists all output items for a specific run.

  See https://platform.openai.com/docs/api-reference/evals/listRunOutputItems for more information.
  """
  def list_run_output_items!(openai = %OpenaiEx{}, eval_id, run_id) do
    openai |> list_run_output_items(eval_id, run_id) |> Http.bang_it!()
  end

  def list_run_output_items(openai = %OpenaiEx{}, eval_id, run_id) do
    openai |> Http.get(ep_url(eval_id, "runs", run_id) <> "/output_items")
  end
end
