defmodule Part1Test do
  use ExUnit.Case

  test "compute sample" do
    assert Part1.compute([1,9,10,3,2,3,11,0,99,30,40,50]) == 3500
  end
end
