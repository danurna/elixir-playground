defmodule Day10 do
  def run_part1() do
    AOCHelper.read_input()
    |> Enum.map(&String.to_integer/1)
    |> Solution.calculate_frequency()
  end

  def run_part2() do
    AOCHelper.read_input()
    |> Enum.map(&String.to_integer/1)
    |> Solution.arrangements()
  end

  def debug_sample() do
    [
      1,
      2,
      3,
      4
    ]
    |> Solution.arrangements()
  end
end

defmodule Solution do
  # Part 1
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

  # Part 2
  def arrangements(input) do
    {:ok, memo_pid} = Agent.start(fn -> %{} end)

    device_joltage = Enum.max(input) + 3
    complete_input = [device_joltage | input]

    complete_input
    |> Enum.sort()
    |> Solution.memoized_find_arrangements(0, memo_pid)
  end

  # Taken from https://elixirforum.com/t/advent-of-code-2020-day-10/36119
  def memoized_find_arrangements(joltages, current, memo_pid) do
    case Agent.get(memo_pid, &Map.get(&1, {joltages, current})) do
      nil ->
        result = find_arrangements(joltages, current, memo_pid)
        Agent.update(memo_pid, &Map.put(&1, {joltages, current}, result))
        result

      result ->
        result
    end
  end

  def find_arrangements([], _current, _memo_pid), do: 1
  def find_arrangements(joltages, current, memo_pid) do
    joltages
    |> Enum.slice(0..2)
    |> Enum.with_index()
    |> Enum.filter(fn {joltage, _index} -> joltage - current <= 3 end)
    |> Enum.map(fn {joltage, index} ->
      {joltage, Enum.slice(joltages, (index + 1)..-1)}
    end)
    |> Enum.map(fn {joltage, tail} ->
      memoized_find_arrangements(tail, joltage, memo_pid)
    end)
    |> Enum.sum()
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
