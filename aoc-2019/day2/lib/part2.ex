defmodule Part2 do

  # What pair of inputs provides output 19690720?
  def calculate_solution() do
    "input.txt"
    |> File.read!()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> find_solution(19690720)
  end

  defp find_solution(input, result) do
    combinations = for noun <- Enum.to_list(0..99), verb <- Enum.to_list(0..99), do: {noun, verb}

    {noun, verb} =
      combinations
      |> Enum.find(fn {noun, verb} -> Part1.compute(input, true, noun, verb) == result end)
      |> IO.inspect

    100 * noun + verb
  end
end
