defmodule RunLengthEncoding do
  def encode(s) when is_binary(s) do 
    s
      |> String.to_charlist 
      |> Enum.reduce(%{}, 
        fn char, map -> 
          case Map.get(map, char, :not_found) do 
            :not_found -> Map.put(map, char, 1)
            count -> Map.put(map, char, count + 1)
          end
        end)
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
