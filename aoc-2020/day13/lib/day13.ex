defmodule Day13 do
  def run_part1() do
    AOCHelper.read_input()
    |> SolutionPart1.run()
  end

  def run_part2() do
    AOCHelper.read_input()
    |> SolutionPart2.run()
  end

  def debug_sample() do
    [
      "939",
      "7,13,x,x,59,x,31,19"
    ]
    |> SolutionPart1.run()
  end
end

defmodule SolutionPart1 do
  def run(input) do
    input
    |> Parser.parse
    |> (fn %{:bus_lines => bus_lines, :timestamp => timestamp} ->
      find_next_bus(timestamp, bus_lines)
    end).()
    |> (fn {wait, line} ->
      wait * line
    end).()
  end

  defp find_next_bus(timestamp, bus_lines) do
    bus_lines
    |> Enum.map(fn line ->
      x = timestamp / line
      {line, floor(x) * line, ceil(x) * line}
    end)
    |> Enum.map(fn {line, bus_before, bus_after} ->
      {bus_after - timestamp, line}
    end)
    |> Enum.sort()
    |> hd
  end
end

defmodule SolutionPart2 do
  def run(input) do
    input
    |> Parser.parse
  end
end

defmodule Parser do
  def parse(input) do
    [cur_time, bus_lines] = input
    %{
      timestamp: String.to_integer(cur_time),
      bus_lines: bus_lines |> String.split(",") |> Enum.filter(&(&1 != "x")) |> Enum.map(&String.to_integer/1)
    }
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
""
