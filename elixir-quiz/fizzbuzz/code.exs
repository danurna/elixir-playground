defmodule ListFizzBuzz do 
  def execute(max) when is_number(max) do 
    Enum.reduce(1..max, [], &([ FizzBuzz.convert(&1) | &2 ]))
      |> Enum.reverse
      |> Enum.join(" ")
  end
end

defmodule FizzBuzz do 
  def convert(number) do
    cond do 
      rem(number, 3) == 0 and rem(number, 5) == 0 -> "FizzBuzz"
      rem(number, 3) == 0 -> "Fizz"
      rem(number, 5) == 0 -> "Buzz"
      true -> number
    end
  end
end

defmodule Main do 
  def main() do 
    ListFizzBuzz.execute(100)
      |> IO.puts 
  end
end

Main.main()
