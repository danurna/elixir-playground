defmodule Day13 do
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
      "939",
      "7,13,x,x,59,x,31,19"
    ]
    |> SolutionPart2.run()
  end
end

defmodule SolutionPart1 do
  def run(input) do
    input
    |> Parser.parse
    |> (fn %{:bus_lines => bus_lines, :timestamp => timestamp} ->
      find_next_bus(timestamp, bus_lines)
    end).()
    |> (fn {wait, line} ->
      wait * line
    end).()
  end

  defp find_next_bus(timestamp, bus_lines) do
    bus_lines
    |> Enum.map(fn line ->
      x = timestamp / line
      {line, floor(x) * line, ceil(x) * line}
    end)
    |> Enum.map(fn {line, _bus_before, bus_after} ->
      {bus_after - timestamp, line}
    end)
    |> Enum.sort()
    |> hd
  end
end

defmodule SolutionPart2 do
  def run(input) do
    input
    |> Parser.parse_without_filter
    |> (fn %{:bus_lines => bus_lines} ->
      next_sequence(bus_lines)
    end).()
  end

  # Fast solution taken from https://elixirforum.com/t/advent-of-code-2020-day-13/36180/5
  def next_sequence(busses) do
    busses
    |> Enum.with_index()
    |> Enum.reduce({0, 1}, &add_to_sequence/2)
    |> elem(0)
  end

  defp add_to_sequence({:x, _index}, state), do: state
  defp add_to_sequence({bus, index}, {t, step}) do
    IO.inspect {{bus, index}, {t, step}}
    if Integer.mod(t + index, bus) == 0 do
      {t, lcm(step, bus)}
    else
      add_to_sequence({bus, index}, {t + step, step})
    end
  end

  defp lcm(a, b) do
    div(a * b, Integer.gcd(a, b))
  end

  # Naive solution (Takes a loooong time).
  defp find_timestamp(bus_lines, range) do
    index_bus_lines =
      bus_lines
      |> Enum.with_index()

    desired_offsets =
      index_bus_lines
      |> Enum.map(fn {_line, offset} ->
        offset
      end)

    index_bus_lines
    |> (fn bus_lines ->
      range
      |> Enum.filter(fn time ->
        Enum.all?(bus_lines, fn {line_number, offset} ->
          # IO.inspect {line_number, offset}
          case line_number do
            :x -> true
            number ->
              rem(time, number) == rem((line_number - offset), line_number)
          end
        end)
      end)
    end).()
      # |> Stream.filter(fn time ->
      #   {first_bus_line, _} = hd(bus_lines)
      #   rem(time, first_bus_line) == 0
      # end)
      # |> Enum.filter(fn time ->
      #   {second_bus_line, _} = Enum.at(bus_lines, 1)
      #   rem(time, second_bus_line) == 1
      # end)
    #   |> Enum.map(fn time ->
    #     offsets_for_time =
    #        bus_lines
    #       |> Enum.map(fn {line, offset} ->
    #         case line do
    #           :x -> offset
    #           line ->
    #             (ceil(time / line) * line) - time
    #         end
    #       end)
    #     {time, offsets_for_time}
    #   end)
    # end).()
    # |> Enum.find(fn {_, offsets} ->
    #   offsets == desired_offsets
    # end)
  end
end

defmodule Parser do
  def parse(input) do
    [cur_time, bus_lines] = input
    %{
      timestamp: String.to_integer(cur_time),
      bus_lines: bus_lines |> String.split(",") |> Enum.filter(&(&1 != "x")) |> Enum.map(&String.to_integer/1)
    }
  end

  def parse_without_filter(input) do
    [cur_time, bus_lines] = input
    %{
      timestamp: String.to_integer(cur_time),
      bus_lines: bus_lines |> String.split(",") |> Enum.map(&Integer.parse/1) |> Enum.map(fn elem ->
      case elem do
        {val, _} -> val
        :error -> :x
      end
    end)
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
""
