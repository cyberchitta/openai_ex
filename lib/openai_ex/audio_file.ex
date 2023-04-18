defmodule OpenaiEx.Audio.File do
  @moduledoc """
  This module provides constructors for OpenAI Audio API File parameter.
  """

  @doc """
  File parameter given different pieces of information
  """
  def new(name: name, content: content) do
    {name, content}
  end

  def new(path: path) do
    {path, File.read!(path)}
  end
end
