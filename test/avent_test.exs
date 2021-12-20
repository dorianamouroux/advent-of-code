defmodule AventTest do
  use ExUnit.Case
  doctest Avent

  test "greets the world" do
    assert Avent.hello() == :world
  end
end
