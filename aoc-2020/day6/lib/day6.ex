defmodule Day6 do
  def run_part1() do
    AOCHelper.read_input()
    |> AnswerValidator.count_any_positive()
  end

  def run_part2() do
    AOCHelper.read_input()
    |> AnswerValidator.count_common_positives()
  end

  def debug_sample() do
    [
      "abc",
      "",
      "a",
      "b",
      "c",
      "",
      "ab",
      "ac",
      "",
      "a",
      "a",
      "a",
      "a",
      "",
      "b"
    ]
    |> AnswerValidator.count_common_positives()
  end
end

defmodule AnswerValidator do
  # Collect answers per group by putting it into one string
  # and count the unique characters afterwards
  def count_any_positive(lines) do
    lines
    |> Enum.reduce([""], fn line, acc ->
      case line do
        "" -> ["" | acc]
        line ->
          [string_acc | other_acc] = acc
          [line <> string_acc | other_acc]
      end
    end)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.uniq/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.sum
  end

  # Collect answers per groups and per person
  # and intersect them inside groups
  def count_common_positives(lines) do
    lines
    |> Enum.reduce([[]], fn line, acc ->
      case line do
        "" -> [[] | acc]
        line ->
          [group | other_groups] = acc
          new_set =
            line
            |> String.graphemes
            |> Enum.reduce(MapSet.new, fn c, s -> MapSet.put(s, c) end)
          [[new_set | group] | other_groups]
      end
    end)
    |> Enum.map(fn group ->
      Enum.reduce(group, hd(group), fn item, combined ->
        MapSet.intersection(combined, item)
      end)
    end)
    |> Enum.map(&Enum.count/1)
    |> Enum.sum
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
