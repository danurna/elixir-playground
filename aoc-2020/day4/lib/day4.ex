defmodule Day4 do
  def run_part1() do
    AOCHelper.read_input()
    |> PassportValidator.validate_batch(false)
  end

  def run_part2() do
    AOCHelper.read_input()
    |> PassportValidator.validate_batch(true)
  end

  def debug_sample() do
    [
      "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd",
      "byr:1937 iyr:2017 cid:147 hgt:183cm",
      "",
      "iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884",
      "hcl:#cfa07d byr:1929",
      "",
      "hcl:#ae17e1 iyr:2013",
      "eyr:2024",
      "ecl:brn pid:760753108 byr:1931",
      "hgt:179cm",
      "",
      "hcl:#cfa07d eyr:2025 pid:166559648",
      "iyr:2011 ecl:brn hgt:59in",
    ]
    |> PassportValidator.validate_batch(false)
  end

  def debug_valid() do
    [
      "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980",
      "hcl:#623a2f",
      "",
      "eyr:2029 ecl:blu cid:129 byr:1989",
      "iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm",
      "",
      "hcl:#888785",
      "hgt:164cm byr:2001 iyr:2015 cid:88",
      "pid:545766238 ecl:hzl",
      "eyr:2022",
      "",
      "iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"
    ]
    |> PassportValidator.validate_batch(true)
  end
end

defmodule PassportValidator do
  def validate_batch(lines, strict) do
    lines
    |> gather_passports
    |> Enum.filter(&has_required_properties/1)
    |> (fn passports ->
      case strict do
        true -> Enum.count(passports, &validate/1)
        false -> Enum.count(passports)
      end
    end).()
  end

  def has_required_properties(passport) do
    ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    |> Enum.all?(&(Map.has_key?(passport, &1)))
  end

  # byr (Birth Year) - four digits; at least 1920 and at most 2002.
  # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  # hgt (Height) - a number followed by either cm or in:
  #     If cm, the number must be at least 150 and at most 193.
  #     If in, the number must be at least 59 and at most 76.
  # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  # pid (Passport ID) - a nine-digit number, including leading zeroes.
  # cid (Country ID) - ignored, missing or not.
  def validate(passport) do
    [
      %{key: "byr", validator: &(number_in_range(&1, 1920, 2002))},
      %{key: "iyr", validator: &(number_in_range(&1, 2010, 2020))},
      %{key: "eyr", validator: &(number_in_range(&1, 2020, 2030))},
      %{key: "hgt", validator: &validate_height/1},
      %{key: "hcl", validator: &validate_hair_color/1},
      %{key: "ecl", validator: &(Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], &1))},
      %{key: "pid", validator: &validate_passport_id/1}
    ]
    |> Enum.all?(fn %{key: key, validator: validator} ->
      Map.fetch!(passport, key)
      |> (&( validator.(&1)  )).()
    end)
  end

  defp number_in_range(value, min, max) do
    value
    |> String.to_integer
    |> (fn v -> v in min..max end).()
  end

  defp validate_height(value) do
    regex = ~r/^((?<cm>\d{3})cm|(?<in>\d{2})in)$/
    case Regex.match?(regex, value) do
      false -> false
      true ->
        %{"cm" => val_cm, "in" => val_in} = Regex.named_captures(regex, value)
        case {val_cm, val_in} do
          {"", value} -> String.to_integer(value) in 59..76
          {value, ""} -> String.to_integer(value) in 150..193
        end
    end
  end

  defp validate_hair_color(value) do
    regex = ~r/^#[0-9a-f]{6}$/
    Regex.match?(regex, value)
  end

  defp validate_passport_id(value) do
    regex = ~r/^[0-9]{9}$/
    Regex.match?(regex, value)
  end

  def gather_passports(input), do: gather_passports(input, [%{}])
  def gather_passports([], passports), do: passports
  def gather_passports(["" | tail], passports), do: gather_passports(tail, [%{} | passports])
  def gather_passports([input | remaining], [this_pp | other_pp]), do: gather_passports(remaining, [ value_pairs(input, this_pp) | other_pp])

  def value_pairs(input, passport) do
    input
    |> String.split(" ")
    |> Enum.reduce(passport, fn pair, acc ->
      pair
      |> String.split(":")
      |> (fn([k, v]) -> Map.put(acc, k, v) end).()
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
