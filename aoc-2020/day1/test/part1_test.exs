defmodule Part1Test do
  use ExUnit.Case
  doctest Part1

  test "greets the world" do
    assert Part1.hello() == :world
  end
end
