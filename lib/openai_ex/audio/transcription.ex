defmodule OpenaiEx.Audio.Transcription do
  @moduledoc """
  This module provides an implementation of the OpenAI audio transcription API. The API
  reference can be found at https://platform.openai.com/docs/api-reference/audio/createTranscription.

  ## API Fields

  The following fields can be used as parameters when creating a new audio request:

  - `:file`
  - `:model`
  - `:language`
  - `:prompt`
  - `:response_format`
  - `:temperature`
  - `:timestamp_granularities`
  """
  @api_fields [
    :file,
    :model,
    :language,
    :prompt,
    :response_format,
    :temperature,
    :timestamp_granularities
  ]

  @doc """
  Creates a new audio request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the audio transcription request.

  ## Returns

  A map containing the fields of the audio transcription request.

  The `:file` and `:model` fields are required.
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{file: _, model: _}) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Calls the audio transcription endpoint.

  ## Arguments

  - `openai`: A map containing the OpenAI configuration.
  - `audio`: A map containing the audio transcription request.

  ## Returns

  A map containing the audio transcription response.

  See https://platform.openai.com/docs/api-reference/audio/createTranscription for more information.
  """
  def create(openai = %OpenaiEx{}, audio = %{}) do
    openai
    |> OpenaiEx.Http.post("/audio/transcriptions",
      multipart: audio |> OpenaiEx.Http.to_multi_part_form_data(file_fields())
    )
  end

  @doc false
  def file_fields() do
    [:file]
  end
end
