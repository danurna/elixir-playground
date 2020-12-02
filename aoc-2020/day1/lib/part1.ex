defmodule Part1 do
  def run() do
    AOCHelper.read_integer_input()
    |> compute()
    |> (&(&1.first * &1.second)).()
  end

  def compute(entries) do
    Enum.reduce_while(entries, [], fn e, _ ->
      filtered_entries = List.delete(entries, e)
      element = Enum.find(filtered_entries, fn o -> e + o == 2020 end)
      case element do
        nil -> {:cont, []}
        x -> {:halt, %{first: e, second: x}}
      end
    end)
  end
end

defmodule Part2 do
  def run() do
    AOCHelper.read_integer_input()
    |> compute()
    |> (&(&1.first * &1.second * &1.third)).()
  end

  def compute(entries) do
    Enum.reduce_while(entries, [], fn e0, _ ->
      filtered_entries = List.delete(entries, e0)

      element =
        Enum.reduce_while(filtered_entries, [], fn e1, _ ->
          more_filtered_entries = List.delete(filtered_entries, e1)
          element = Enum.find(more_filtered_entries, fn e2 -> e0 + e1 + e2 == 2020 end)
          case element do
            nil -> {:cont, nil}
            x -> {:halt, %{first: e0, second: e1, third: x}}
          end
        end)

      case element do
        nil -> {:cont, []}
        e -> {:halt, e}
      end
    end)
  end
end

defmodule AOCHelper do
  def read_input() do
    "input.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&(String.replace(&1, "\r", "")))
    |> Enum.map(&(String.split(&1, ",")))
  end

  def read_integer_input() do
    "input.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&(String.replace(&1, "\r", "")))
    |> Enum.map(&String.to_integer/1)
  end
end
