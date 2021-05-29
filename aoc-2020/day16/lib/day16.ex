defmodule Day16 do
  def run_part1() do
    AOCHelper.read_input()
    |> SolutionPart1.solve()
  end

  def run_part2() do
    AOCHelper.read_input()
    |> hd
    |> SolutionPart2.run()
  end

  def debug_sample() do
    "class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7,1,14

    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12"
    |> SolutionPart1.run()
  end
end

defmodule SolutionPart1 do
  def solve(input) do
    lines = input |> String.split("\n") |> Enum.map(&(String.trim(&1))) |> Enum.filter(&(&1 != ""))

    my_ticket_marker = Enum.find_index(lines, fn l -> l == "your ticket:" end)
    nearby_tickets_marker = Enum.find_index(lines, fn l -> l == "nearby tickets:" end)

    raw_rules = Enum.slice(lines, 0..my_ticket_marker-1)
    # raw_my_ticket = Enum.slice(lines, my_ticket_marker + 1, 1) |> hd
    raw_nearby_tickets = Enum.slice(lines, nearby_tickets_marker + 1, Enum.count(lines))

    rules = parse_rules(raw_rules)

    all_nearby_ticket_numbers = raw_nearby_tickets |> Enum.join(",") |> String.split(",") |> Enum.map(&(String.to_integer(&1)))
    all_valid_numbers = rules |> Enum.map(&(Map.get(&1, :ranges))) |> List.flatten |> Enum.map(&Enum.to_list/1) |> List.flatten

    invalid_numbers =
      all_nearby_ticket_numbers
      |> Enum.reject(fn x ->
        Enum.member?(all_valid_numbers, x)
      end)

    Enum.sum(invalid_numbers)
  end

  defp parse_rules(lines), do: parse_rules(lines, [])
  defp parse_rules([rule | rules], acc), do: parse_rules(rules, [parse_rule(rule) | acc])
  defp parse_rules([], acc), do: acc

  defp parse_rule(line) do
    line
    |> String.split(":")
    |> (fn [name, range_string] ->
      %{
        name: name,
        ranges: parse_ranges(range_string)
      }
    end).()
  end

  defp parse_ranges(ranges) do
    ranges
    |> String.split("or")
    |> Enum.map(&(String.trim(&1)))
    |> Enum.map(fn raw_range ->
        raw_range
        |> String.split("-")
        |> Enum.map(&(String.to_integer(&1)))
        |> (fn [start_val, end_val] ->
          Range.new(start_val, end_val)
        end).()
    end)
  end
end

defmodule SolutionPart2 do
  def run(input) do
    input
  end
end

defmodule AOCHelper do
  def read_input() do
    "input.txt"
    |> File.read!()
  end
end
