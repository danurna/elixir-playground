defmodule Part1 do
  def run do
    123257..647015
    |> valid_passwords()
    |> length()
  end

  def valid_passwords(range) do
    range
    |> Enum.reject(&is_valid/1)
  end

  def is_valid(p) do
    has_six_digits(p) &&
    has_any_same_adjacent_digits(p) &&
    has_no_decreasing_digits(p)
  end

  defp has_six_digits(p) do
    p
    |> Integer.to_charlist()
    |> length()
    |> (&(&1 == 6)).()
  end

  defp has_any_same_adjacent_digits(p) do
    p
    |> Integer.to_charlist()
    |> Enum.reduce(%{last: nil, found: false}, fn c, acc ->
      if acc.last == c do
        %{last: c, found: true}
      else
        %{last: c, found: acc.found}
      end
    end)
    |> Map.fetch!(:found)
  end

  defp has_no_decreasing_digits(p) do
    p
    |> Integer.to_charlist()
    |> Enum.reduce(%{last: nil, always_ascending: true}, fn c, acc ->
      if acc.last == nil do
        %{last: c, always_ascending: true}
      else
        r = acc.always_ascending && c >= acc.last
        %{last: c, always_ascending: r}
      end
    end)
    |> Map.fetch!(:always_ascending)
  end
end
