defmodule Day6 do
  def run_part1() do
    AOCHelper.read_input()
    |> AnswerValidator.count_any_positive()
  end

  def run_part2() do
    AOCHelper.read_input()
    |> AnswerValidator.count_any_positive()
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
    |> AnswerValidator.count_any_positive()
  end
end

defmodule AnswerValidator do
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
end

defmodule AOCHelper do
  def read_input() do
    "input.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&(String.replace(&1, "\r", "")))
  end
end
