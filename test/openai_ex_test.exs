defmodule OpenaiExTest do
  use ExUnit.Case
  doctest OpenaiEx.Chat.Completions
  doctest OpenaiEx.Completion
  doctest OpenaiEx.ChatMessage
  doctest OpenaiEx.Embeddings
  doctest OpenaiEx.Images.Generate
  doctest OpenaiEx.Moderations
  doctest OpenaiEx.MsgContent
  doctest OpenaiEx.Beta.Assistants
  doctest OpenaiEx.Beta.Threads.Runs
  doctest OpenaiEx.Containers
  doctest OpenaiEx.ContainerFiles
  doctest OpenaiEx.VectorStores
end
