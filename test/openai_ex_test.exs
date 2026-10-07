defmodule OpenaiExTest do
  use ExUnit.Case
  doctest OpenaiEx.Chat.Completions
  doctest OpenaiEx.Completion
  doctest OpenaiEx.ChatMessage
  doctest OpenaiEx.Embeddings
  doctest OpenaiEx.Images.Generate
  doctest OpenaiEx.Moderations
  doctest OpenaiEx.Decisions
  doctest OpenaiEx.MsgContent
  doctest OpenaiEx.Containers
  doctest OpenaiEx.ContainerFiles
  doctest OpenaiEx.VectorStores
  doctest OpenaiEx.Beta.Agents
  doctest OpenaiEx.Beta.Agents.Sessions

  test "inspecting the client does not print the token" do
    inspected = OpenaiEx.new("sk-secret") |> inspect()
    refute inspected =~ "sk-secret"
    inspected = OpenaiEx._for_azure("azure-secret", "res", "dep", "2024-01-01") |> inspect()
    refute inspected =~ "azure-secret"
  end

  test "errors redact credential headers on the attached request" do
    request =
      Finch.build(:get, "https://api.openai.com/v1/models", [
        {"Authorization", "Bearer sk-secret"},
        {"api-key", "azure-secret"},
        {"OpenAI-Beta", "assistants=v2"}
      ])

    error = OpenaiEx.Error.api_timeout_error(request)

    assert error.request.headers == [
             {"Authorization", "[REDACTED]"},
             {"api-key", "[REDACTED]"},
             {"OpenAI-Beta", "assistants=v2"}
           ]
  end
end
