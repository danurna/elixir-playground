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
    "1,3,2"
    |> SolutionPart2.run()
  end
end

defmodule SolutionPart1 do
  def run(input) do
    input
  end
end

defmodule SolutionPart2 do
  def run(input) do
    initial_numbers =
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    initial_state =
      initial_numbers
      |> Enum.map(fn x -> {x, :new} end)
      |> Enum.into(%{})
      |> (fn map ->
        %{last_elem: List.last(initial_numbers), last_occurences: map}
      end).()

    start = Enum.count(initial_numbers) - 1
    [start..2020]
    |> Enum.reduce(initial_state, fn iteration, %{:last_elem => last_elem, :last_occurences => last_occurences} ->
      case Map.get(last_occurences, last_elem, :unseen) do
        :unseen ->
          elem = 0
          %{last_elem: elem, Map.put(last_occurences, elem, iteration)}

      end
    end)
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
