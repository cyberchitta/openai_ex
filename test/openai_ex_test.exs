defmodule OpenaiExTest do
  use ExUnit.Case
  doctest OpenaiEx.ChatCompletion
  doctest OpenaiEx.Completion
  doctest OpenaiEx.ChatMessage
  doctest OpenaiEx.Embedding
  doctest OpenaiEx.Image
  doctest OpenaiEx.Moderation
  doctest OpenaiEx.MsgContent
  doctest OpenaiEx.Beta.Assistant
end
