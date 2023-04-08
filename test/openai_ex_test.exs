defmodule OpenaiExTest do
  use ExUnit.Case
  doctest OpenaiEx

  test "greets the world" do
    assert OpenaiEx.hello() == :world
  end
end
