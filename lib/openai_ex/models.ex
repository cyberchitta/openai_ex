defmodule OpenaiEx.Models do
  @moduledoc """
  This module provides an implementation of the OpenAI Models API. Information about these models can be found at https://platform.openai.com/docs/models.
  """
  alias OpenaiEx.Http

  defp ep_url(model \\ nil) do
    "/models" <> if(is_nil(model), do: "", else: "/#{model}")
  end

  @doc """
  Lists the available models.

  https://platform.openai.com/docs/api-reference/models/list
  """
  def list!(openai = %OpenaiEx{}) do
    openai |> list() |> Http.bang_it!()
  end

  def list(openai = %OpenaiEx{}) do
    openai |> Http.get(ep_url())
  end

  @doc """
  Retrieves a specific model.

  https://platform.openai.com/docs/api-reference/models/retrieve
  """
  def retrieve!(openai = %OpenaiEx{}, model) do
    openai |> retrieve(model) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, model) do
    openai |> Http.get(ep_url(model))
  end

  @doc """
  Deletes a specific model.

  https://platform.openai.com/docs/api-reference/fine-tunes/delete-model
  """
  def delete!(openai = %OpenaiEx{}, model) do
    openai |> delete(model) |> Http.bang_it!()
  end

  def delete(openai = %OpenaiEx{}, model) do
    openai |> Http.delete(ep_url(model))
  end
end
