defmodule Day7 do
  def run_part1() do
    AOCHelper.read_input()
    |> Solution.count_bags_containing(:shiny_gold)
  end

  def run_part2() do
    AOCHelper.read_input()
    |> Solution.count_bags_inside_bag(:shiny_gold)
  end

  def debug_sample() do
    [
      "light red bags contain 1 bright white bag, 2 muted yellow bags.",
      "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
      "bright white bags contain 1 shiny gold bag.",
      "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
      "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
      "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
      "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
      "faded blue bags contain no other bags.",
      "dotted black bags contain no other bags.",
    ]
    |> Solution.compute()
  end
end

defmodule Solution do
  def count_bags_inside_bag(lines, root_bag) do
    lines
    |> RuleParser.build_rules()
    |> count(root_bag)
  end

  def count(rules, root_bag), do: count(rules, root_bag, 0)
  def count(rules, root_bag, sum) do
    Map.fetch!(rules, root_bag)
    |> Enum.map(fn {bag, count} ->
      count + count * count(rules, bag, 0)
    end)
    |> Enum.sum
  end

  def count_bags_containing(lines, bag_identifier) do
    lines
    |> RuleParser.build_rules()
    |> find_possibilities([bag_identifier])
    |> Enum.count
  end

  def find_possibilities(rules, identifiers), do: find_possibilities(rules, identifiers, MapSet.new())
  def find_possibilities(rules, [], acc), do: acc
  def find_possibilities(rules, [head | tail], acc) do
      rules
      |> Map.keys
      |> Enum.filter(fn k ->
        rules
        |> Map.fetch!(k)
        |> (&Map.has_key?(&1, head)).()
      end)
      |> (fn result ->
        result
        |> (&(MapSet.new(&1))).()
        |> (&(MapSet.union(&1, acc))).()
        |> (&(MapSet.union(&1, find_possibilities(rules, Enum.to_list(&1), acc)))).()
        |> (&(MapSet.union(&1, find_possibilities(rules, tail, acc)))).()
      end).()
  end
end

defmodule RuleParser do
  def build_rules(raw_rules), do: build_rules(raw_rules, %{})
  def build_rules([], rules), do: rules
  def build_rules([head | tail], rules) do
    build_rules(tail, Map.merge(rules, build_rule(head)))
  end

  def build_rule(line) do
    [bag, content] = line |> String.split(" contain ")

    bag_identifier =
      bag
      |> String.trim_trailing(" bags")
      |> String.replace(" ", "_")
      |> String.to_atom()

    content_map =
      content
      |> String.split(", ")
      |> Enum.map(fn bag_rule ->
        case bag_rule do
          "no other bags." -> %{}
          rule ->
            {quantity, bag_name} =
              rule
              |> String.trim_trailing(".")
              |> String.trim_trailing(" bags")
              |> String.trim_trailing(" bag")
              |> (&(Integer.parse(&1))).()

            bag_identifier =
              bag_name
              |> String.trim_leading(" ")
              |> String.replace(" ", "_")
              |> String.to_atom()

            %{bag_identifier => quantity}
        end
      end)
      |> Enum.reduce(&Map.merge/2)

    %{bag_identifier => content_map}
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
