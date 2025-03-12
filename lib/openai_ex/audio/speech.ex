defmodule OpenaiEx.Audio.Speech do
  @moduledoc """
  This module provides an implementation of the OpenAI audio speech API. The API reference can be found at https://platform.openai.com/docs/api-reference/audio/createSpeech.
  """
  alias OpenaiEx.Http

  @api_fields [
    :input,
    :model,
    :voice,
    :response_format,
    :speed
  ]

  @doc """
  Creates a new audio speech request
  """
  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{input: _, model: _, voice: _}) do
    args |> Map.take(@api_fields)
  end

  @doc """
  Calls the audio speech endpoint.

  See https://platform.openai.com/docs/api-reference/audio/createSpeech for more information.
  """
  def create!(openai = %OpenaiEx{}, audio = %{}) do
    openai |> create(audio) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, audio = %{}) do
    openai |> Http.post_no_decode("/audio/speech", json: audio |> Map.take(@api_fields))
  end
end
