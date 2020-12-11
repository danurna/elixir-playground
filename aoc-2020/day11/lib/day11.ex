defmodule Day11 do
  def run_part1() do
    AOCHelper.read_input()
    |> Solution.run(:adjacent)
  end

  def run_part2() do
    AOCHelper.read_input()
    |> Solution.run(:search)
  end

  def debug_sample() do
    [
      "L.LL.LL.LL",
      "LLLLLLL.LL",
      "L.L.L..L..",
      "LLLL.LL.LL",
      "L.LL.LL.LL",
      "L.LLLLL.LL",
      "..L.L.....",
      "LLLLLLLLLL",
      "L.LLLLLL.L",
      "L.LLLLL.LL"
    ]
    |> Solution.run(:adjacent)
  end
end

defmodule Solution do
  def run(input, mode) do
    {grid, width, height} = MapParser.parse(input)
    grid
    |> update_grid_until_stable(0, width, height, mode)
  end

  def update_grid_until_stable(grid, iteration_count, width, height, mode) do
    updated_grid =
      grid
      |> Enum.into(%{}, fn item ->
        case item do
          :floor -> :floor
          seat ->
            update_grid_item(seat, grid, width, height, mode)
        end
      end)

    case updated_grid == grid do
      true ->
        taken_seats = grid |> Map.values() |> Enum.count(&(&1 == :taken))
        {:converged, iteration_count, taken_seats}

      false -> update_grid_until_stable(updated_grid, iteration_count + 1, width, height, mode)
    end
  end

  def update_grid_item({pos, item}, grid, width, height, mode) do
    taken_seats =
      surrounding(mode, grid, pos, width, height)
      |> Enum.count(&(&1 == :taken))

    updated_item =
      case {taken_seats, item, mode} do
        {0, :available, _} -> :taken
        {x, :taken, :search} when x >= 5 -> :available
        {x, :taken, :adjacent} when x >= 4 -> :available
        {_, _, _} -> item
      end

    {pos, updated_item}
  end

  defp surrounding(mode, grid, pos, width, height) do
    {row, column} = pos
    case mode do
      :search ->
        [
          find_visible_seat(grid, pos, :top_left, width, height),
          find_visible_seat(grid, pos, :top, width, height),
          find_visible_seat(grid, pos, :top_right, width, height),
          find_visible_seat(grid, pos, :right, width, height),
          find_visible_seat(grid, pos, :bottom_right, width, height),
          find_visible_seat(grid, pos, :bottom, width, height),
          find_visible_seat(grid, pos, :bottom_left, width, height),
          find_visible_seat(grid, pos, :left, width, height)
        ]
      :adjacent ->
        [
          Map.get(grid, {row-1, column-1}, :floor),
          Map.get(grid, {row-1, column}, :floor),
          Map.get(grid, {row-1, column+1}, :floor),
          Map.get(grid, {row, column+1}, :floor),
          Map.get(grid, {row+1, column+1}, :floor),
          Map.get(grid, {row+1, column}, :floor),
          Map.get(grid, {row+1, column-1}, :floor),
          Map.get(grid, {row, column-1}, :floor)
        ]
    end
  end

  def find_visible_seat(grid, position, direction, width, height) do
    step_function =
      case direction do
        :top_left -> (fn {row, column} ->
          {row-1, column-1}
        end)
        :top -> (fn {row, column} ->
          {row-1, column}
        end)
        :top_right -> (fn {row, column} ->
          {row-1, column+1}
        end)
        :right -> (fn {row, column} ->
          {row, column+1}
        end)
        :bottom_right -> (fn {row, column} ->
          {row+1, column+1}
        end)
        :bottom -> (fn {row, column} ->
          {row+1, column}
        end)
        :bottom_left -> (fn {row, column} ->
          {row+1, column-1}
        end)
        :left -> (fn {row, column} ->
          {row, column-1}
        end)
      end

    walk(grid, apply(step_function, [position]), step_function, width, height)
  end

  def walk(grid, position, step_function, width, height) do
    case position do
      {-1, _} -> :floor
      {^height, _} -> :floor
      {_, -1} -> :floor
      {_, ^width} -> :floor
      position ->
        case Map.fetch!(grid, position) do
          :floor ->
            walk(grid, apply(step_function, [position]), step_function, width, height)
          seat ->
            seat
        end
    end
  end
end

defmodule MapParser do

  def parse(input) do
    height = Enum.count(input)
    width = input |> hd |> String.graphemes |> Enum.count

    grid =
      input
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, row_idx}, acc ->
        row
        |> String.graphemes
        |> Enum.with_index
        |> Enum.map(fn {grid_item, column_idx} ->
          item =
            case grid_item do
              "L" -> :available
              "#" -> :taken
              "." -> :floor
            end
          {{row_idx, column_idx}, item}
        end)
        |> (fn mapped_row ->
          mapped_row
          |> Map.new()
          |> Map.merge(acc)
        end).()
      end)

    {grid, width, height}
  end

end

defmodule Visualiser do
  def visualise(grid) do
    grid
    |> Enum.sort()
    |> Enum.map(fn {pos, item} ->
      case pos do
        {_, 0} -> "\n" <> char(item)
        _ ->
          char(item)
      end
    end)
    |> Enum.join()
    |> String.split("\n")
    |> Enum.each(&(IO.inspect &1))
  end

  defp char(item) do
    case item do
      :taken -> "#"
      :available -> "L"
      :floor -> "."
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
