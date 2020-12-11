defmodule Day11 do
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
    |> Solution.run()
  end
end

defmodule Solution do
  def run(input) do
    input
    |> MapParser.parse()
    |> update_grid_until_stable(0)
  end

  def update_grid_until_stable(grid, iteration_count) do
    updated_grid =
      grid
      |> Enum.into(%{}, fn item ->
        update_grid_item(item, grid)
      end)

    case updated_grid == grid do
      true ->
        taken_seats = grid |> Map.values() |> Enum.count(&(&1 == :taken))
        {:converged, iteration_count, taken_seats}

      false -> update_grid_until_stable(updated_grid, iteration_count + 1)
    end
  end

  def update_grid_item({{row, column}, item}, grid) do
    adjacent =
     %{
        top_left: Map.get(grid, {row-1, column-1}, :floor),
        top: Map.get(grid, {row-1, column}, :floor),
        top_right: Map.get(grid, {row-1, column+1}, :floor),
        right: Map.get(grid, {row, column+1}, :floor),
        bottom_right: Map.get(grid, {row+1, column+1}, :floor),
        bottom: Map.get(grid, {row+1, column}, :floor),
        bottom_left: Map.get(grid, {row+1, column-1}, :floor),
        left: Map.get(grid, {row, column-1}, :floor)
      }

    taken_seats =
      adjacent
      |> Map.values()
      |> Enum.count(&(&1 == :taken))

    updated_item =
      case {taken_seats, item} do
        {0, :available} -> :taken
        {x, :taken} when x >= 4 -> :available
        {_, _} -> item
      end

    {{row, column}, updated_item}
  end
end

defmodule MapParser do

  def parse(input) do
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
