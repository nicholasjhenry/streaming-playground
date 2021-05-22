defmodule StreamingPlaygroundTest do
  use ExUnit.Case
  doctest StreamingPlayground

  test "greets the world" do
    assert StreamingPlayground.hello() == :world
  end
end
