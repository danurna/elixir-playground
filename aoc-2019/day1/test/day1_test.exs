defmodule Day1Test do
  use ExUnit.Case

  test "calculates fuel" do
    assert Day1.total_fuel([12]) == 2
    assert Day1.total_fuel([14]) == 2
    assert Day1.total_fuel([1969]) == 654
    assert Day1.total_fuel([100756]) == 33583
  end

  test "calculates fuel for many inputs" do
    assert Day1.total_fuel([12, 14, 1969]) == 658
  end
end
