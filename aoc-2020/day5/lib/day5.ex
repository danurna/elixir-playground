defmodule Day5 do
  def run_part1() do
    AOCHelper.read_input()
    |> SeatSearcher.search_max()
  end

  def run_part2() do
    AOCHelper.read_input()
    |> SeatSearcher.search_missing_seat()
  end

  # "FBFBBFFRLR" --> row 44, column 5 --> 44 * 8 + 5 = 357
  def debug_sample() do
    [
      "FBFBBFFRLR"
    ]
    |> SeatSearcher.search_max()
  end
end

defmodule SeatSearcher do
  def search_max(lines) do
    lines
    |> generate_seat_ids()
    |> Enum.max()
  end

  def search_missing_seat(lines) do
    lines
    |> generate_seat_ids()
    |> Enum.sort()
    |> Enum.reduce(%{prev_id: nil, result: nil}, fn id, acc ->
      case acc.prev_id do
        nil -> %{prev_id: id, result: acc.result}
        prev_id when prev_id == id - 1 -> %{prev_id: id, result: acc.result}
        prev_id when prev_id == id - 2 -> %{prev_id: id, result: id - 1}
      end
    end)
  end

  defp generate_seat_ids(lines) do
    lines
    |> Enum.map(&find_seat/1)
    |> Enum.map(fn seat -> seat.row * 8 + seat.column end)
  end

  def find_seat(line) do
    << row_instr :: binary-size(7), seat_instr :: binary-size(3) >> = line
    %{
      row: find_number(String.graphemes(row_instr), %{l: 0, u: 127}, "F", "B"),
      column: find_number(String.graphemes(seat_instr), %{l: 0, u: 7}, "L", "R")
    }
  end

  defp find_number([], range, _lower_marker, _upper_marker), do: range.l
  defp find_number([instr | rest], range, lower_marker, upper_marker) do
    span = (range.u - range.l) + 1
    case instr do
      ^lower_marker -> find_number(rest, %{l: range.l, u: range.u - span/2}, lower_marker, upper_marker)
      ^upper_marker -> find_number(rest, %{l: range.l + span/2, u: range.u}, lower_marker, upper_marker)
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
