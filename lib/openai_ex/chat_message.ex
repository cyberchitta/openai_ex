defmodule OpenaiEx.ChatMessage do
  @moduledoc """
  This module provides an implementation of the OpenAI chat message API. Information about these messages can be found at   https://platform.openai.com/docs/guides/chat/introduction.

  ## API Fields

  The following fields can be used as parameters when creating a new chat message:

  - `:content`
  - `:role`
  - `:function_call`
  - `:name`
  """

  defp new(role, content) do
    new(content, role, nil, nil)
  end

  defp new(content, role, function_call, name) do
    %{
      content: content,
      role: role
    }
    |> (&if(!is_nil(function_call), do: Map.put(&1, :function_call, function_call), else: &1)).()
    |> (&if(!is_nil(name), do: Map.put(&1, :name, name), else: &1)).()
  end

  @doc """
  Create a `ChatMessage` map with role `system`.

  Example usage:

      iex> _message = OpenaiEx.ChatMessage.system("Hello, world!")
      %{content: "Hello, world!", role: "system"}
  """
  def system(content), do: new("system", content)

  @doc """
  Create a `ChatMessage` map with role `user`.

  Example usage:

      iex> _message = OpenaiEx.ChatMessage.user("Hello, world!")
      %{content: "Hello, world!", role: "user"}
  """
  def user(content), do: new("user", content)

  @doc """
  Create a `ChatMessage` map with role `assistant`.

  Example usage:

      iex> _message = OpenaiEx.ChatMessage.assistant("Hello, world!")
      %{content: "Hello, world!", role: "assistant"}
  """
  def assistant(content), do: new("assistant", content)

  @doc """
  Create a `ChatMessage` map with role `function`.

  Example usage:

      iex> _message = OpenaiEx.ChatMessage.function("greet", "Hello, world!")
      %{content: "Hello, world!", role: "function", name: "greet"}
  """
  def function(name, content), do: new(content, "function", nil, name)
end
