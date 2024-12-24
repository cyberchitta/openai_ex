defmodule OpenaiEx.ChatMessage do
  @moduledoc """
  This module provides an elixir map wrapper around the OpenAI message JSON
  object which is used in the chat completions and assistants APIs.
  """
  @map_fields [
    :content,
    :role,
    :name,
    :tool_call_id
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
  Create a `ChatMessage` map with role `developer`.

  Example usage:

      iex> _message = OpenaiEx.ChatMessage.developer("Hello, world!")
      %{content: "Hello, world!", role: "developer"}
  """
  def developer(content), do: new(role: "developer", content: content)

  @doc """
  Create a `ChatMessage` map with role `user`.

  Example usage:

      iex> _message = OpenaiEx.ChatMessage.user("Hello, world!")
      %{content: "Hello, world!", role: "user"}
  """
  def user(content), do: new(role: "user", content: content)

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

      iex> _message = OpenaiEx.ChatMessage.tool("call_sjflkje", "greet", "Hello, world!")
      %{content: "Hello, world!", role: "tool", name: "greet", tool_call_id: "call_sjflkje"}
  """
  def tool(tool_call_id, name, content),
    do: new(role: "tool", tool_call_id: tool_call_id, content: content, name: name)
end
