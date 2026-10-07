defmodule OpenaiEx.Audio.Voices do
  @moduledoc """
  This module provides an implementation of the OpenAI custom voice creation API. The API reference can be found at https://platform.openai.com/docs/api-reference/audio/createVoice.
  """
  alias OpenaiEx.Http

  @api_fields [
    :name,
    :type,
    :audio_sample,
    :consent,
    :prompt,
    :model,
    :script_hint
  ]

  @doc """
  Creates a new voice request with the given arguments.

  A voice is created either from an `audio_sample` (with a `consent` id), or from a text `prompt` with `type: "prompt"`.
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{name: _}) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Calls the voice creation endpoint. The request is always sent as multipart form data.

  See https://platform.openai.com/docs/api-reference/audio/createVoice for more information.
  """
  def create!(openai = %OpenaiEx{}, voice = %{}) do
    openai |> create(voice) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, voice = %{}) do
    multipart = voice |> Map.take(@api_fields) |> Http.to_multi_part_form_data(file_fields())
    openai |> Http.post("/audio/voices", multipart: multipart)
  end

  @doc false
  def file_fields() do
    [:audio_sample]
  end
end
