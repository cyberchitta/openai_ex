defmodule OpenaiEx.Audio do
  @moduledoc """
  This module provides an implementation of the OpenAI audio API. The API reference can be found at https://platform.openai.com/docs/api-reference/audio.

  ## API Fields

  The following fields can be used as parameters when creating a new audio request:

  - `:file`
  - `:model`
  - `:prompt`
  - `:response_format`
  - `:temperature`
  - `:language`
  """
  @api_fields [
    :file,
    :model,
    :prompt,
    :response_format,
    :temperature,
    :language
  ]

  @doc """
  Creates a new audio request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the audio request.

  ## Returns

  A map containing the fields of the audio request.

  The `:file` and `:model` fields are required.
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{file: file, model: model}) do
    %{
      file: file,
      model: model
    }
    |> Map.merge(args)
    |> Map.take(@api_fields)
  end

  @doc """
  Calls the audio transcription endpoint.

  ## Arguments

  - `openai`: A map containing the OpenAI configuration.
  - `audio`: A map containing the audio request.

  ## Returns

  A map containing the audio response.

  See https://platform.openai.com/docs/api-reference/audio/create for more information.
  """
  def transcribe(openai = %OpenaiEx{}, audio = %{}) do
    openai
    |> OpenaiEx.Http.post("/audio/transcriptions",
      multipart: audio |> OpenaiEx.Http.to_multi_part_form_data(file_fields())
    )
  end

  @doc """
  Calls the audio translation endpoint.

  ## Arguments

  - `openai`: A map containing the OpenAI configuration.
  - `audio`: A map containing the audio request.

  ## Returns

  A map containing the audio response.

  See https://platform.openai.com/docs/api-reference/audio/create for more information.
  """
  def translate(openai = %OpenaiEx{}, audio = %{}) do
    openai
    |> OpenaiEx.Http.post("/audio/translations",
      multipart: audio |> OpenaiEx.Http.to_multi_part_form_data(file_fields())
    )
  end

  @doc false
  def file_fields() do
    [:file]
  end
end
