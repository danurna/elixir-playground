defmodule Part1 do
  def run() do
    AOCHelper.read_input()
    |> compute()
  end

  def compute(lines) do
    Enum.reduce(lines, 0, fn line, acc ->
      e = Parser.extract(line)
      lower = e.lower
      upper = e.upper

      frequencies =
        e.password
        |> String.graphemes()
        |> Enum.frequencies()

      case Map.fetch(frequencies, e.char) do
        {:ok, x} when x in lower..upper -> acc + 1
        _ -> acc
      end
    end)
  end
end

defmodule Part2 do
  def run() do
    AOCHelper.read_input()
    |> compute()
  end

  def compute(lines) do
    Enum.reduce(lines, 0, fn line, acc ->
      e = Parser.extract(line)
      lower_idx = e.lower - 1
      upper_idx = e.upper - 1

      occurence_count =
        e.password
        |> String.graphemes()
        |>  (fn g -> [Enum.at(g, lower_idx), Enum.at(g, upper_idx)] end).()
        |> Enum.count(&(&1 == e.char))

      case occurence_count do
        1 -> acc + 1
        _ -> acc
      end
    end)
  end
end

defmodule Parser do
  def extract(line) do
    regex = ~r/(?<l>\d*)-(?<u>\d*) (?<c>\w): (?<p>\w*)/
    %{"l" => l, "u" => u, "c" => c, "p" => p} = Regex.named_captures(regex, line)
    %{
      lower: String.to_integer(l),
      upper: String.to_integer(u),
      char: c,
      password: p
    }
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
