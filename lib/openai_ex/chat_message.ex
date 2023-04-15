defmodule OpenaiEx.ChatMessage do
  @moduledoc """
  https://platform.openai.com/docs/guides/chat/introduction
  """

  @api_fields [:role, :content]

  defp new(role, content) do
    %{
      role: role,
      content: content
    }
    |> Map.take(@api_fields)
  end

  def system(content), do: new("system", content)

  def user(content), do: new("user", content)

  def assistant(content), do: new("assistant", content)
end
