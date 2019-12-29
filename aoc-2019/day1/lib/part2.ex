defmodule Part2 do
  def total_fuel(input) do
    input
    |> Enum.reduce(0, fn x, acc -> acc + fuel(x) end)
  end

  defp fuel(acc \\ 0, mass) do
    case simple_fuel(mass) do
      x when x <= 0 -> acc
      x -> fuel(acc + x, x)
    end
  end

  defp simple_fuel(mass) do
    mass
    |> (&(floor(&1/3) - 2)).()
  end

  def calculate_solution() do
    "input_part2.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> total_fuel()
  end
end
