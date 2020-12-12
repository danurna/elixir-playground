defmodule Day12 do
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
      "F10",
      "N3",
      "F7",
      "R90",
      "F11"
    ]
    |> SolutionPart2.run()
  end
end

defmodule SolutionPart2 do
  def run(input) do
    input
    |> Parser.parse
    |> move()
    |> (fn result ->
      %{:x => x, :y => y} = result
      abs(x) + abs(y)
    end).()
  end

  defp move(instr), do: move(instr, %{x: 0, y: 0}, %{delta_x: 10, delta_y: 1})
  defp move([], pos, _waypoint), do: pos
  defp move([head | tail], pos, waypoint) do
    case head do
      {:turn_left, _} ->
        updated_waypoint = turn_waypoint(head, waypoint)
        move(tail, pos, updated_waypoint)
      {:turn_right, _} ->
        updated_waypoint = turn_waypoint(head, waypoint)
        move(tail, pos, updated_waypoint)
      {:forward, val} ->
        updated_pos = move_to_waypoint(val, pos, waypoint)
        move(tail, updated_pos, waypoint)
      instr ->
        updated_waypoint = move_waypoint(instr, waypoint)
        move(tail, pos, updated_waypoint)
    end
  end

  defp turn_waypoint(instr, waypoint) do
    degrees =
      case instr do
        {:turn_left, deg} -> deg
        {:turn_right, deg} -> -deg
      end

    {x, y} = turn_vector({waypoint.delta_x, waypoint.delta_y}, degrees)
    %{delta_x: round(x), delta_y: round(y)}
  end

  defp turn_vector({x, y}, deg) do
    rad = deg * :math.pi() / 180
    {
      x*:math.cos(rad) - y*:math.sin(rad),
      x*:math.sin(rad) + y*:math.cos(rad)
    }
  end

  defp move_waypoint(instr, wp) do
    case instr do
      {:north, val} -> %{ wp | delta_y: wp.delta_y + val}
      {:south, val} -> %{ wp | delta_y: wp.delta_y - val}
      {:east, val} -> %{ wp | delta_x: wp.delta_x + val}
      {:west, val} -> %{ wp | delta_x: wp.delta_x - val}
    end
  end

  defp move_to_waypoint(multiplier, pos, waypoint) do
    %{
      x: pos.x + (waypoint.delta_x * multiplier),
      y: pos.y + (waypoint.delta_y * multiplier)
    }
  end
end

defmodule SolutionPart1 do
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
