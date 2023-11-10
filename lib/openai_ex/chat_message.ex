defmodule OpenaiEx.ChatMessage do
  @moduledoc """
  This module provides an elixir map wrapper around the OpenAI message JSON
  object which is used in the chat completions and assistants APIs.

  The following fields can be used as parameters when creating a new chat message:

  - `content`
  - `role`
  - `name`
  - `file_ids`
  """
  @map_fields [
    :content,
    :role,
    :name,
    :file_ids
  ]

  defp new(args = [_ | _]), do: args |> Enum.into(%{}) |> new()

  defp new(params = %{}) do
    params
    |> Map.take(@map_fields)
    |> Enum.filter(fn {_, v} -> !is_nil(v) end)
    |> Enum.into(%{})
  end

  @doc """
  Create a `ChatMessage` map with role `system`.

  Example usage:

      iex> _message = OpenaiEx.ChatMessage.system("Hello, world!")
      %{content: "Hello, world!", role: "system"}
  """
  def system(content), do: new(role: "system", content: content)

  @doc """
  Create a `ChatMessage` map with role `user`.

  Example usage:

      iex> _message = OpenaiEx.ChatMessage.user("Hello, world!")
      %{content: "Hello, world!", role: "user"}
  """
  def user(content, file_ids \\ nil), do: new(role: "user", content: content, file_ids: file_ids)

  @doc """
  Create a `ChatMessage` map with role `assistant`.

  Example usage:

      iex> _message = OpenaiEx.ChatMessage.assistant("Hello, world!")
      %{content: "Hello, world!", role: "assistant"}
  """
  def assistant(content), do: new(role: "assistant", content: content)

  @doc """
  Create a `ChatMessage` map with role `function`.

  Example usage:

      iex> _message = OpenaiEx.ChatMessage.tool("greet", "Hello, world!")
      %{content: "Hello, world!", role: "function", name: "greet"}
  """
  def tool(name, content), do: new(role: "function", content: content, name: name)
end
