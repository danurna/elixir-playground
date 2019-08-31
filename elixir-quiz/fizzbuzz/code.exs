defmodule FizzBuzz do 
  def up_to(n) when is_number(n) do 
    Enum.reduce(1..n, [], &([ convert(&1) | &2 ]))
      |> Enum.reverse
      |> Enum.join(" ")
  end 
  
  defp convert(number) do
    cond do 
      rem(number, 15) == 0 -> "FizzBuzz"
      rem(number, 3) == 0 -> "Fizz"
      rem(number, 5) == 0 -> "Buzz"
      true -> number
    end
  end
end

defmodule Main do 
  def main() do 
    FizzBuzz.up_to(100)
      |> IO.puts 
  end
end

Main.main()
