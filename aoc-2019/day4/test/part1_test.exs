defmodule Part1Test do
  use ExUnit.Case

  test "detects valid password" do
    assert Part1.is_valid(111111) == true
  end

  test "detects missing adjacent digits" do
    assert Part1.is_valid(123789) == false
  end

  test "detects decreasing digits" do
    assert Part1.is_valid(223450) == false
  end
end
