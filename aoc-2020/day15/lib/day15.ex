defmodule Day15 do
  def run_part1() do
    AOCHelper.read_input()
    |> hd
    |> SolutionPart1.run()
  end

  def run_part2() do
    AOCHelper.read_input()
    |> hd
    |> SolutionPart2.run()
  end

  def debug_sample() do
    "0,3,6"
    |> SolutionPart2.run()
  end
end

defmodule SolutionPart1 do
  def run(input) do
    initial_numbers =
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    Enum.count(initial_numbers)+1..30000000
    |> Enum.reduce(Enum.reverse(initial_numbers), fn iteration, seen_elems ->
      [{last_elem_v, last_elem_idx} | other_elems] =
        seen_elems
        |> Enum.with_index()
      {_, last_occur_idx} = Enum.find(other_elems, {last_elem_v, last_elem_idx}, fn {v, _} ->
        v == last_elem_v
      end)
      spoken = abs(last_elem_idx - last_occur_idx)
      [spoken | seen_elems]
    end)
    |> hd
  end
end

defmodule SolutionPart2 do
  def run(input) do
    input
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
