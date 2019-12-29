defmodule Part2Test do
  use ExUnit.Case

  test "calculates fuel" do
    assert Part2.total_fuel([14]) == 2
    assert Part2.total_fuel([1969]) == 966
    assert Part2.total_fuel([100756]) == 50346
  end
end
