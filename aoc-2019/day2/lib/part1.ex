defmodule Part1 do

  def compute(instructions, modify \\ false, noun \\ 12, verb \\ 2) do
    # To map
    indexed_instructions =
      instructions
      |> Enum.with_index
      |> Enum.into(%{}, fn {x, i} -> {i, x} end)

    if modify == true do
      indexed_instructions
      |> Map.put(1, noun)
      |> Map.put(2, verb)
      |> execute(0)
      |> Map.get(0)
    else
      indexed_instructions
      |> execute(0)
      |> Map.get(0)
    end
  end

  def execute(instructions, pointer) do
    opcode = Map.get(instructions, pointer)

    case opcode do
      1 ->
        # Add
        a_pos = Map.get(instructions, pointer + 1)
        b_pos = Map.get(instructions, pointer + 2)
        r_pos = Map.get(instructions, pointer + 3)
        a = Map.get(instructions, a_pos)
        b = Map.get(instructions, b_pos)

        instructions
        |> Map.put(r_pos, a + b)
        |> execute(pointer + 4)
      2 ->
        # Multiply
        a_pos = Map.get(instructions, pointer + 1)
        b_pos = Map.get(instructions, pointer + 2)
        r_pos = Map.get(instructions, pointer + 3)
        a = Map.get(instructions, a_pos)
        b = Map.get(instructions, b_pos)

        instructions
        |> Map.put(r_pos, a * b)
        |> execute(pointer + 4)
      99 ->
        # Terminate
        instructions
    end
  end

  def calculate_solution() do
    "input.txt"
    |> File.read!()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> compute(true)
  end
end
