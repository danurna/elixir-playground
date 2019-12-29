defmodule Day1 do
  @moduledoc """
  Input:
    For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2.
    For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2.
    For a mass of 1969, the fuel required is 654.
    For a mass of 100756, the fuel required is 33583.
  """
  def total_fuel(input) do
    input
    |> Enum.reduce(0, fn x, acc -> acc + fuel(x) end)
  end

  defp fuel(mass) do
    mass
    |> (&(floor(&1/3) - 2)).()
  end

  def calculate_solution() do
    "input_part1.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> total_fuel()
  end
end
