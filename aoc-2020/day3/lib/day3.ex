defmodule Part1 do
  def run() do
    AOCHelper.read_input()
    |> compute()
  end

  def debug_sample() do
    [
      "..##.......",
      "#...#...#..",
      ".#....#..#.",
      "..#.#...#.#",
      ".#...##..#.",
      "..#.##.....",
      ".#.#.#....#",
      ".#........#",
      "#.##...#...",
      "#...##....#",
      ".#..#...#.#",
    ]
    |> compute
  end

  def debug_run() do
    ["..#.", "..#.", "#..#"]
    |> compute
  end

  # Current line = 0
  # Current offset = 0
  # Step = %{right: 3, down: 1}
  #
  # [".", ".", "#", "."]
  # [".", ".", "#", "."]
  # ["#", ".", ".", "#"]

  # Example --> 4 tree
  # [".", ".", "# H", "."]
  # [".", ".", "# H", "."]
  # ["# H", ".", ".", "# H"]

  # offset = (offset + 2) modulo Grid_width

  def compute(lines) do
    _ = length(lines)
    line_width = hd(lines) |> String.length()

    step = %{right: 3, down: 1}
    start_pointer = %{x: 0, y: 0}

    Enum.reduce(lines, %{pointer: start_pointer, count: 0}, fn line, state ->
      start_x = state.pointer.x
      end_x = state.pointer.x + step.right

      IO.inspect(line)

      updated_state =
        Enum.reduce([start_x, end_x], state, fn x, h_state ->
          updated_pointer = %{x: x, y: h_state.pointer.y}
          norm_x = rem(x, line_width)

          case String.at(line, norm_x) do
            "#" -> %{pointer: updated_pointer, count: h_state.count + 1} |> IO.inspect
            _ -> %{pointer: updated_pointer, count: h_state.count}
          end
        end)
      %{
        pointer: %{x: updated_state.pointer.x, y: updated_state.pointer.y + 1},
        count: updated_state.count
      }
    end)

  end
end

defmodule Part2 do
  def run() do
    AOCHelper.read_input()
    |> compute()
  end

  def compute(_lines) do
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
