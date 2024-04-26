defmodule OpenaiExTest do
  use ExUnit.Case
  doctest OpenaiEx.Chat.Completions
  doctest OpenaiEx.Completion
  doctest OpenaiEx.ChatMessage
  doctest OpenaiEx.Embeddings
  doctest OpenaiEx.Images.Generate
  doctest OpenaiEx.Moderation
  doctest OpenaiEx.MsgContent
  doctest OpenaiEx.Beta.Assistant
  doctest OpenaiEx.Beta.Thread.Run
end
