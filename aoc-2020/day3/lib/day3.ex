defmodule Part1 do
  def run() do
    AOCHelper.read_input()
    |> TreeCounter.eval()
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
    |> TreeCounter.eval()
  end

  def debug_run() do
    ["..#.", "..#.", "#..#"]
    |> TreeCounter.eval()
  end
end

defmodule TreeCounter do
  def eval(list), do: eval(list, 1, 0, %{x: 0, y: 0})
  def eval(list, step_width), do: eval(list, step_width, 0, %{x: 0, y: 0})
  def eval([], _step_width, sum, _pointer), do: sum
  def eval([head | tail], step_width, sum, p), do: eval(tail, step_width, sum + tree_count(head, p), %{x: p.x + step_width, y: p.y + 1})

  def tree_count(line, pointer) when is_binary(line) do
    norm_x = pointer.x |> rem(String.length(line))
    case String.at(line, norm_x) do
      "#" -> 1
      _ -> 0
    end
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
    slopes
    |> Enum.map(fn slope ->
      %{step_width: slope.right, lines: Enum.take_every(lines, slope.down)}
    end)
    |> Enum.map(fn t ->
      TreeCounter.eval(t.lines, t.step_width)
    end)
    |> Enum.reduce(&*/2)
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
