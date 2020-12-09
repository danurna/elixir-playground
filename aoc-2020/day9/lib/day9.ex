defmodule Day9 do
  def run_part1() do
    AOCHelper.read_input()
    |> Enum.map(&String.to_integer/1)
    |> Attacker.first_invalid_number(25)
  end

  def run_part2() do
    input =
      AOCHelper.read_input()
      |> Enum.map(&String.to_integer/1)

    invalid_number = Attacker.first_invalid_number(input, 25)
    Attacker.find_set(input, invalid_number)
    |> Enum.min_max()
    |> Tuple.to_list()
    |> Enum.sum()
  end

  def debug_sample() do
    [
      "35",
      "20",
      "15",
      "25",
      "47",
      "40",
      "62",
      "55",
      "65",
      "95",
      "102",
      "117",
      "150",
      "182",
      "127",
      "219",
      "299",
      "277",
      "309",
      "576"
    ]
    |> Enum.map(&String.to_integer/1)
    |> Attacker.find_set(127)
  end
end

defmodule Attacker do
  # Part 2
  def find_set([], number), do: {:error, :no_solution}
  def find_set(input, number) do
    case sum_with_next(input, number, []) do
      {:error, _} -> find_set(tl(input), number)
      {:ok, set} -> set
    end
  end

  defp sum_with_next([head | tail], number, set) do
    updated_set = [head | set]
    case Enum.sum(updated_set) do
      ^number -> {:ok, updated_set}
      x when x > number -> {:error, :exceeded}
      _ -> sum_with_next(tail, number, updated_set)
    end
  end

  # Part 1
  def first_invalid_number([], _preamble_size) do
    {:ok, :all_valid}
  end

  def first_invalid_number(input, preamble_size) do
    preamble = Enum.take(input, preamble_size)
    number = Enum.at(input, preamble_size)

    is_valid =
      preamble
      |> Enum.sort()
      |> (&(find_fit(&1, number))).()

    case is_valid do
      true -> first_invalid_number(tl(input), preamble_size)
      false -> number
    end
  end

  defp find_fit([], target), do: false
  defp find_fit([head | tail], target) do
    all_sums =
      tail
      |> Enum.map(&(head + &1))

    case Enum.member?(all_sums, target) do
      true -> true
      false ->
        find_fit(tail, target)
    end
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
