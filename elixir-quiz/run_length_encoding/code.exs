defmodule RunLengthEncoding do
  def encode(s) when is_binary(s) do 
    String.to_charlist(s)
      |> Enum.reduce([], &(reducer(&1, &2)))
      |> Enum.reverse
      |> convert
  end 

  defp reducer(char, []) do
    [{char, 1}]
  end

  defp reducer(char, [{k, v} | tail]) do
    cond do 
      char == k -> [{k, v + 1} | tail]
      true -> [{char, 1} | [{k, v} | tail]]
    end 
  end

  defp convert({k, v}) do 
    Integer.to_string(v) <> <<k>>
  end

  defp convert([]) do 
    "" 
  end

  defp convert([head | tail]) do
    convert(head) <> convert(tail)
  end
end 

ExUnit.start

defmodule RunLengthEncodingTests do
  use ExUnit.Case
  
  test "One single character" do
    assert RunLengthEncoding.encode("A") == "1A"
  end

  test "N single characters" do
    assert RunLengthEncoding.encode("AAA") == "3A"
  end

  test "Single occurence of multiple characters" do
    assert RunLengthEncoding.encode("ABC") == "1A1B1C"
  end
  
  test "Many occurences of multiple characters" do
    assert RunLengthEncoding.encode("ABBCCCDDE") == "1A2B3C2D1E"
  end
end

RunLengthEncoding.encode("JJJTTWPPMMMMYYYYYYYYYVVVVVV")
  |> IO.puts
