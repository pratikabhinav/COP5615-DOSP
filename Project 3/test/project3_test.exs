defmodule MNTest do
  use ExUnit.Case
  doctest MN

  test "greets the world" do
    assert MN.hello() == :world
  end
end
