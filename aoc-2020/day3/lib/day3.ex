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

  def compute(lines) do
    _ = length(lines)
    line_width = hd(lines) |> String.length()

    step = %{right: 3, down: 1}
    start_pointer = %{x: 0, y: 0}

    index_lines = Enum.with_index(lines)
    Enum.reduce(index_lines, %{pointer: start_pointer, count: 0}, fn {line, idx}, state ->
      norm_x = rem(state.pointer.x, line_width)
      updated_count =
        case String.at(line, norm_x) do
          "#" ->  state.count + 1
          _ -> state.count
        end

      updated_pointer = %{x: state.pointer.x + step.right, y: state.pointer.y + 1}

      %{
        pointer: updated_pointer,
        count: updated_count
      }
    end)
  end
end

defmodule Part2 do
  def run() do
    AOCHelper.read_input()
    |> compute([
      %{right: 1, down: 1},
      %{right: 3, down: 1},
      %{right: 5, down: 1},
      %{right: 7, down: 1},
      %{right: 1, down: 2}
      ])
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
    |> compute([
      %{right: 3, down: 1}
      ])
  end

  def compute(lines, slopes) do
    _ = length(lines)
    line_width = hd(lines) |> String.length()

    Enum.reduce(slopes, %{sum: 1}, fn slope, state ->

      filtered_lines = Enum.take_every(lines, slope.down)
      slope_result =
        Enum.reduce(filtered_lines, %{pointer: %{x: 0, y: 0}, count: 0}, fn line, state ->
          norm_x = rem(state.pointer.x, line_width)
          updated_count =
            case String.at(line, norm_x) do
              "#" ->  state.count + 1
              _ -> state.count
            end

          updated_pointer = %{x: state.pointer.x + slope.right, y: state.pointer.y + slope.down}

          %{
            pointer: updated_pointer,
            count: updated_count
          }
        end)

      %{
        sum: state.sum * slope_result.count
      }
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
