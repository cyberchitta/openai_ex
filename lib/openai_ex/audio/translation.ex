defmodule OpenaiEx.Audio.Translation do
  @moduledoc """
  This module provides an implementation of the OpenAI audio translation API. The API reference can be found at https://platform.openai.com/docs/api-reference/audio/createTranslation.
  """
  alias OpenaiEx.Http

  @api_fields [
    :file,
    :model,
    :prompt,
    :response_format,
    :temperature
  ]

  @doc """
  Creates a new audio translation request
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{file: _, model: _}) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Calls the audio translation endpoint.

  See https://platform.openai.com/docs/api-reference/audio/createTranslation for more information.
  """
  def create!(openai = %OpenaiEx{}, audio = %{}) do
    openai |> create(audio) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, audio = %{}) do
    multipart = audio |> Http.to_multi_part_form_data(file_fields())
    openai |> Http.post("/audio/translations", multipart: multipart)
  end

  @doc false
  def file_fields() do
    [:file]
  end
end
