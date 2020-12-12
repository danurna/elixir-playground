defmodule Day12 do
  def run_part1() do
    AOCHelper.read_input()
    |> Solution.run()
  end

  def run_part2() do
    AOCHelper.read_input()
    |> Solution.run()
  end

  def debug_sample() do
    [
      "F10",
      "N3",
      "F7",
      "R90",
      "F11"
    ]
    |> Solution.run()
  end
end

defmodule Solution do
  def run(input) do
    input
    |> Parser.parse
    |> move()
    |> (fn result ->
      %{:x => x, :y => y} = result
      abs(x) + abs(y)
    end).()
  end

  defp move(instr), do: move(instr, :east, %{x: 0, y: 0})
  defp move([], _cur_dir, pos), do: pos
  defp move([head | tail], cur_dir, pos) do
    case head do
      {:turn_left, _} ->
        updated_dir = update_direction(cur_dir, head)
        move(tail, updated_dir, pos)
      {:turn_right, _} ->
        updated_dir = update_direction(cur_dir, head)
        move(tail, updated_dir, pos)
      {:forward, val} ->
        move([{cur_dir, val} | tail], cur_dir, pos)
      instr ->
        move(tail, cur_dir, update_pos(instr, pos))
    end
  end

  defp update_pos(instr, pos) do
    case instr do
      {:north, val} -> %{ pos | y: pos.y + val }
      {:south, val} -> %{ pos | y: pos.y - val }
      {:east, val} -> %{ pos | x: pos.x + val }
      {:west, val} -> %{ pos | x: pos.x - val }
    end
  end

  defp update_direction(cur_dir, {action, val}) do
    cur_dir_in_deg =
      case cur_dir do
        :north -> 0
        :east -> 90
        :south -> 180
        :west -> 270
      end

    updated_dir_in_deg =
      case {action, val} do
        {:turn_left, val} ->
          cur_dir_in_deg - val
        {:turn_right, val} ->
          cur_dir_in_deg + val
      end

    updated_dir_in_deg
    |> (&(rem(&1, 360))).()
    |> (fn dir_in_deg ->
      case dir_in_deg do
        -270 -> :east
        -180 -> :south
        -90 -> :west
        0 -> :north
        90 -> :east
        180 -> :south
        270 -> :west
      end
    end).()
  end
end

defmodule Parser do
  def parse(input) do
    input
    |> Enum.map(fn line ->
      action =
        case String.first(line) do
          "N" -> :north
          "S" -> :south
          "E" -> :east
          "W" -> :west
          "L" -> :turn_left
          "R" -> :turn_right
          "F" -> :forward
        end
      value = String.slice(line, 1, 100) |> String.to_integer()
      {action, value}
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
