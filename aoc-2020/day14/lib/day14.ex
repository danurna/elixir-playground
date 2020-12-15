defmodule Day14 do
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
      "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X",
      "mem[8] = 11",
      "mem[7] = 101",
      "mem[8] = 0"
    ]
    |> SolutionPart1.run()
  end
end

defmodule SolutionPart1 do
  def run(input) do
    input
    |> Parser.parse
    |> Enum.reduce(%{active_mask: ""}, fn instr, acc ->
      case instr do
        {:mask, bitmask} ->
          Map.put(acc, :active_mask, bitmask)
        {:mem, mem_address, value} ->
          modified_val = apply_mask(value, Map.fetch!(acc, :active_mask))
          Map.put(acc, mem_address, modified_val)
      end
    end)
    |> Map.delete(:active_mask)
    |> Map.values()
    |> Enum.sum()
  end

  defp apply_mask(value, mask) do
    and_mask = mask |> String.replace("X", "1") |> BitStringParser.to_integer()
    or_mask = mask |> String.replace("X", "0") |> BitStringParser.to_integer()
    value
    |> Bitwise.band(and_mask)
    |> Bitwise.bor(or_mask)
  end
end

defmodule SolutionPart2 do
  def run(input) do
    input
  end
end

defmodule Parser do
  def parse(input) do
    input
    |> Enum.map(fn instr ->
      case String.starts_with?(instr, "mask") do
        true ->
          "mask = " <> bitmask = instr
          {:mask, bitmask}
        false ->
          [mem | [val]] = String.split(instr, " = ")
          mem_address =
            mem
            |> String.replace_leading("mem[", "")
            |> String.replace_trailing("]", "")
            |> String.to_integer()

          {:mem, mem_address, String.to_integer(val)}
      end
    end)
  end
end

defmodule BitStringParser do
  def to_integer(bitstring) do
    bitstring
    |> String.reverse
    |> String.graphemes
    |> Enum.with_index
    |> Enum.map(fn {v, idx} ->
      String.to_integer(v) * :math.pow(2, idx)
    end)
    |> Enum.sum
    |> round
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
