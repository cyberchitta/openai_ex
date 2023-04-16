defmodule OpenaiEx.ChatMessage do
  @moduledoc """
  This module provides an implementation of the OpenAI chat message API. Information about these messages can be found at   https://platform.openai.com/docs/guides/chat/introduction.

  ## API Fields

  The following fields can be used as parameters when creating a new chat message:

  - `:content`
  - `:role`
  """

  defp new(role, content) do
    %{
      role: role,
      content: content
    }
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
end
