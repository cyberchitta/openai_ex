defmodule OpenaiEx.Decisions do
  @moduledoc """
  This module provides an implementation of the OpenAI decisions API. The API reference can be found at https://platform.openai.com/docs/api-reference/decisions.
  """
  alias OpenaiEx.Http

  @api_fields [
    :input,
    :model,
    :questions,
    :safety_identifier
  ]

  @doc """
  Creates a new decision request with the given arguments.

  Example usage:

      iex> OpenaiEx.Decisions.new(model: "gpt-6-luna", input: "The sky is blue.", questions: [%{type: "predicate", instructions: "Is the sky described as blue?"}])
      %{
        input: "The sky is blue.",
        model: "gpt-6-luna",
        questions: [%{type: "predicate", instructions: "Is the sky described as blue?"}]
      }
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{input: _, model: _, questions: _}) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Calls the decisions endpoint.

  See https://platform.openai.com/docs/api-reference/decisions/create for more information.
  """
  def create!(openai = %OpenaiEx{}, decision) do
    openai |> create(decision) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, decision) do
    openai |> Http.post("/decisions", json: decision |> Map.take(@api_fields))
  end
end
