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
  doctest OpenaiEx.Beta.Assistants
  doctest OpenaiEx.Beta.Threads.Runs
  doctest OpenaiEx.Containers
  doctest OpenaiEx.ContainerFiles
  doctest OpenaiEx.VectorStores

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
