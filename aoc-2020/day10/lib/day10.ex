defmodule Day10 do
  def run_part1() do
    AOCHelper.read_input()
    |> Enum.map(&String.to_integer/1)
    |> Solution.calculate_frequency()
  end

  def run_part2() do
    AOCHelper.read_input()
    |> Enum.map(&String.to_integer/1)
    |> Solution.calculate_frequency()
  end

  def debug_sample() do
    [
      "28",
      "33",
      "18",
      "42",
      "31",
      "14",
      "46",
      "20",
      "48",
      "47",
      "24",
      "23",
      "49",
      "45",
      "19",
      "38",
      "39",
      "11",
      "1",
      "32",
      "25",
      "35",
      "8",
      "17",
      "7",
      "9",
      "4",
      "2",
      "34",
      "10",
      "3"
    ]
    |> Enum.map(&String.to_integer/1)
    |> Solution.calculate_frequency()
  end
end

defmodule Solution do
  def calculate_frequency(input) do
    device_joltage = Enum.max(input) + 3
    complete_input = [device_joltage | input]

    complete_input
    |> Enum.sort
    |> difference_to_next(0, [])
    |> Enum.frequencies()
    |> (fn %{1 => x, 3 => y} -> x*y end).()
  end

  defp difference_to_next([], _reference, differences), do: differences
  defp difference_to_next([head | tail], reference, differences) do
    difference_to_next(tail, head, [head - reference | differences])
  end
end

defmodule AOCHelper do
  def read_input() do
    "input.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&(String.replace(&1, "\r", "")))
  end
end
