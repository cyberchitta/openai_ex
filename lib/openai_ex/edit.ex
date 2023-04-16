defmodule OpenaiEx.Edit do
  @moduledoc """
  This module provides an implementation of the OpenAI edits API. The API reference can be found at https://beta.openai.com/docs/api-reference/edits.

  ## API Fields

  The following fields can be used as parameters when creating a new edit:
  - `:model`
  - `:input`
  - `:instruction`
  - `:n`
  - `:temperature`
  - `:top_p`
  """
  @api_fields [
    :model,
    :input,
    :instruction,
    :n,
    :temperature,
    :top_p
  ]

  @doc """
  Creates a new edit request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the edit request.

  ## Returns

  A map containing the fields of the edit request.

  The `:model` and `:instruction` fields are required.

  Example usage:

      iex> _request = OpenaiEx.Edit.new([model: "davinci", instruction: "This is a test"])
      %{instruction: "This is a test", model: "davinci"}

      iex> _request = OpenaiEx.Edit.new(%{model: "davinci", instruction: "This is a test"})
      %{instruction: "This is a test", model: "davinci"}
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{model: model, instruction: instruction}) do
    %{
      model: model,
      instruction: instruction
    }
    |> Map.merge(args)
    |> Map.take(@api_fields)
  end

  @doc """
  Calls the edit endpoint using the given `openai` configuration and the given `edit` request.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `edit`: The edit request, as a map with keys corresponding to the API fields.

  ## Returns

  A map containing the fields of the edit response.

  See https://platform.openai.com/docs/api-reference/edits/create for more information.
  """
  def create(openai = %OpenaiEx{}, edit = %{}) do
    openai |> OpenaiEx.post("/edits", edit |> Map.take(@api_fields))
  end
end
