defmodule Day8 do
  def run_part1() do
    AOCHelper.read_input()
    |> Executor.supervised_execution()
  end

  def run_part2() do
    AOCHelper.read_input()
    |> Executor.supervised_execution()
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
    |> Executor.supervised_execution()
  end
end

defmodule Executor do
  def supervised_execution(raw_instructions) do
    raw_instructions
    |> InstructionParser.build_instructions()
    |> execute_until_repeat(%{pointer: 0, acc: 0})
  end

  defp execute_until_repeat(instructions, state) do
    current_pointer = state.pointer
    current_instr = Enum.at(instructions, state.pointer)

    case current_instr.execution_count do
      1 -> {current_instr, state}
      0 ->
        updated_instructions =
          instructions
          |> Enum.with_index()
          |> Enum.map(fn {instr, idx} ->
            case idx do
              ^current_pointer -> Map.put(instr, :execution_count, instr.execution_count + 1)
              _ -> instr
            end
          end)

        updated_state = execute(current_instr.op, current_instr.arg, state)
        execute_until_repeat(updated_instructions, updated_state)
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
