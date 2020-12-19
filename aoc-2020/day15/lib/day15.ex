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

    Enum.count(initial_numbers)+1..2020
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
    initial_numbers =
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    indexed_numbers =
      initial_numbers
      |> Enum.with_index()
      |> Enum.reverse()

    initial_state =
      indexed_numbers
      |> tl
      |> Enum.into(%{})

    {start_elem, _} = hd(indexed_numbers)

    Enum.count(initial_numbers)+1..30000000
    |> Enum.reduce({start_elem, initial_state}, fn iteration, {last_spoken, number_to_last_idx_map} ->
      cur_idx = iteration - 1
      case Map.get(number_to_last_idx_map, last_spoken, :not_found) do
        :not_found ->
          {0, Map.put(number_to_last_idx_map, last_spoken, cur_idx - 1)}
        last_idx ->
          new_spoken = abs(cur_idx - 1 - last_idx)
          {new_spoken, Map.put(number_to_last_idx_map, last_spoken, cur_idx - 1)}
      end
    end)
    |> (fn {last_spoken, _} -> last_spoken end).()
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
