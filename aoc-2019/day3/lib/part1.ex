defmodule Part1 do
  def run() do
    AOCHelper.read_input()
    |> find_closest_intersection()
  end

  def find_closest_intersection(wires) do
    wires
    |> GridHelper.draw_wires(%{})
    |> find_smallest_distance()
  end

  defp find_smallest_distance(grid) do
    distances =
      GridHelper.crossings(grid)
      |> Enum.map(fn {{x, y}, _} ->
        abs(x) + abs(y)
      end)

    distances
    |> Enum.sort()
    |> hd()
  end
end

defmodule Part2 do
  def run() do
    AOCHelper.read_input()
    |> draw_and_find_intersection()
  end

  def draw_and_find_intersection(wires) do
    wires
    |> GridHelper.draw_wires(%{})
    |> find_minimal_wire_length_intersection()
  end

  def find_minimal_wire_length_intersection(grid) do
    distances =
      GridHelper.crossings(grid)
      |> Enum.map(fn {_, entry} ->
        entry.lengths
        |> Map.values
        |> Enum.sum
      end)

    distances
    |> Enum.sort()
    |> hd()
  end
end

defmodule GridHelper do
  def draw_wires(wires, grid) do
    wires
    |> Enum.reduce(grid, fn instructions, grid ->
      draw_wire(instructions, grid)
    end)
  end

  defp draw_wire(instructions, grid) do
    start_point = %{x: 0, y: 0}
    line_id = AOCHelper.random_string(3)

    instructions
    |> Enum.reduce(%{point: start_point, grid: grid, wire_length: 1}, fn instruction, acc ->
      {end_point, updated_grid, updated_wire_length} =
        draw_line(
          acc.grid,
          acc.point,
          instruction,
          line_id,
          acc.wire_length
        )

      %{
        point: end_point,
        grid: updated_grid,
        wire_length: updated_wire_length
      }
    end)
    |> Map.fetch!(:grid)
  end

  defp draw_line(grid, from, instruction, line_id, wire_length) do
    points =
      case instruction do
        "U" <> l ->
          l = String.to_integer(l)
          for y <- from.y-1..from.y-l, do: {from.x, y}
        "R" <> l ->
          l = String.to_integer(l)
          for x <- from.x+1..from.x+l, do: {x, from.y}
        "D" <> l ->
          l = String.to_integer(l)
          for y <- from.y+1..from.y+l, do: {from.x, y}
        "L" <> l ->
          l = String.to_integer(l)
          for x <- from.x-1..from.x-l, do: {x, from.y}
      end

    updated =
      points
      |> Enum.reduce(%{grid: grid, wire_length: wire_length}, fn p, acc ->
        {updated_grid, updated_wire_length} = add_point(acc.grid, p, line_id, acc.wire_length)
        %{grid: updated_grid, wire_length: updated_wire_length}
      end)

    {x, y} = points |> Enum.reverse |> hd
    {%{x: x, y: y}, updated.grid, updated.wire_length}
  end

  defp add_point(grid, point, line_id, wire_length) do
    grid_entry = Map.get(grid, point, %{wires: MapSet.new(), lengths: %{}})
    updated_wires =
      grid_entry.wires
      |> MapSet.put(line_id)

    updated_length =
      grid_entry.lengths
      |> Map.put(line_id, wire_length)

    grid = Map.put(grid, point, %{wires: updated_wires, lengths: updated_length})
    {grid, wire_length + 1}
  end

  def crossings(grid) do
    grid
    |> Enum.filter(fn {_, entry} ->
      length(MapSet.to_list(entry.wires)) == 2
    end)
  end
end

defmodule AOCHelper do
  def read_input() do
    "input.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&(String.split(&1, ",")))
  end

  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
