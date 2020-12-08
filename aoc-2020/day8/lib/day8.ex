defmodule Day8 do
  def run_part1() do
    AOCHelper.read_input()
    |> Executor.supervised_execution()
  end

  def run_part2() do
    AOCHelper.read_input()
    |> Executor.mutating_execution()
  end

  def debug_sample() do
    [
      "nop +0",
      "acc +1",
      "jmp +4",
      "acc +3",
      "jmp -3",
      "acc -99",
      "acc +1",
      "jmp -4",
      "acc +6"
    ]
    |> Executor.mutating_execution()
  end
end

defmodule Executor do
  # Part 1
  def supervised_execution(raw_instructions) do
    raw_instructions
    |> InstructionParser.build_instructions()
    |> execute_until_repeat(%{pointer: 0, acc: 0})
  end

  # Part 2
  def mutating_execution(raw_instructions) do
    raw_instructions
    |> InstructionParser.build_instructions()
    |> create_mutated_instructions()
    |> Stream.map(&(execute_until_repeat(&1, %{pointer: 0, acc: 0})))
    |> Enum.filter(fn result ->
      case result do
        {:terminated, _} -> false
        _ -> true
      end
    end)
  end

  # Creates a new collection of instructions
  # for every :nop or :jmp found with the appropriate replacement.
  defp create_mutated_instructions(instructions) do
    instructions
    |> Stream.with_index()
    |> Enum.reduce(MapSet.new([instructions]), fn {instr, idx}, acc ->
      case instr.op do
        :nop ->
          instructions
          |> List.update_at(idx, &(Map.put(&1, :op, :jmp)))
          |> (&(MapSet.new([&1]))).()
          |> (&(MapSet.union(acc, &1))).()
        :jmp ->
          instructions
          |> List.update_at(idx, &(Map.put(&1, :op, :nop)))
          |> (&(MapSet.new([&1]))).()
          |> (&(MapSet.union(acc, &1))).()
        _ ->
          acc
      end
    end)
  end

  defp execute_until_repeat(instructions, state) do
    current_instr = Enum.at(instructions, state.pointer)

    termination_pointer = Enum.count(instructions)
    case state.pointer do
      ^termination_pointer -> state
      current_pointer ->
        case current_instr.execution_count do
          1 -> {:terminated, state}
          _ ->
            updated_instructions =
              instructions
              |> List.update_at(current_pointer, &(Map.put(&1, :execution_count, &1.execution_count + 1)))

            updated_state = execute(current_instr.op, current_instr.arg, state)
            execute_until_repeat(updated_instructions, updated_state)
        end
    end
  end

  defp execute(:nop, _arg, %{:pointer => pointer, :acc => acc}), do: %{pointer: pointer + 1, acc: acc}
  defp execute(:acc, arg, %{:pointer => pointer, :acc => acc}), do: %{pointer: pointer + 1, acc: acc + arg}
  defp execute(:jmp, arg, %{:pointer => pointer, :acc => acc}), do: %{pointer: pointer + arg, acc: acc}
end

defmodule InstructionParser do
  def build_instructions(raw_instructions) do
    raw_instructions
    |> Enum.map(fn raw_instr ->
      [raw_op, raw_arg] = String.split(raw_instr, " ")
      %{
        :op => String.to_atom(raw_op),
        :arg => String.to_integer(raw_arg),
        execution_count: 0
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
