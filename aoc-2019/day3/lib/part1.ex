defmodule Part1 do
  @start_coords %{x: 0, y: 0}

  def run() do
    AOCHelper.read_input()
    |> find_closest_intersection()
  end

  def find_closest_intersection(wires) do
    wires
    |> draw_wires(%{}, @start_coords)
    |> find_smallest_distance(@start_coords)
  end

  defp draw_wires(wires, grid, start_coords) do
    wires
    |> Enum.reduce(grid, fn instructions, grid ->
      draw_wire(instructions, grid, start_coords)
    end)
  end

  defp draw_wire(instructions, grid, from) do
    IO.inspect(instructions, label: "draw_wire")

    line_id = AOCHelper.random_string(3)

    instructions
    |> Enum.reduce(%{point: from, grid: grid}, fn instruction, acc ->
      {end_point, updated_grid} = draw_line(acc.grid, acc.point, instruction, line_id)
      %{point: end_point, grid: updated_grid}
    end)
    |> Map.fetch!(:grid)
  end

  def draw_line(grid, from, instruction, line_id) do
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

    updated_grid =
      points
      |> Enum.reduce(grid, fn p, acc -> add_point(acc, p, line_id) end)

    {x, y} = points |> Enum.reverse |> hd
    {%{x: x, y: y}, updated_grid}
  end

  defp add_point(grid, point, line_id) do
    updated_wires =
      Map.get(grid, point, MapSet.new())
      |> MapSet.put(line_id)

    Map.put(grid, point, updated_wires)
  end

  defp find_smallest_distance(grid, start_coords) do
    # Find coordinates with two lines crossing
    crossings =
      grid
      |> Enum.filter(fn {_, wires} ->
        length(MapSet.to_list(wires)) == 2
      end)

    distances =
      crossings
      |> Enum.map(fn {{x, y}, _} ->
        abs(start_coords.x - x) + abs(start_coords.y - y)
      end)

    distances
    |> Enum.sort()
    |> hd()
  end
end

defmodule AOCHelper do
  def read_input() do
    "input.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&(String.split(&1, ",")))
  end

  def create_grid(width, height) do
    coordinates = for x <- 0..width, y <- 0..height, do: {x, y}

    coordinates
    |> Enum.into(%{}, fn c -> {c, []} end)
  end

  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
