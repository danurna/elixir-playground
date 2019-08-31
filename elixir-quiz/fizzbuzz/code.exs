defmodule FizzBuzz do 
  
  def execute(upperRange) when is_number(upperRange) do
    execute(1, upperRange)
  end 

  defp execute(l, u) when l < u do 
    fizzbuzz(l)
      |> IO.puts
    execute(l + 1, u)
  end

  defp execute(l, _u) do 
    fizzbuzz(l)
      |> IO.puts
  end

  defp fizzbuzz(number) do
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
    FizzBuzz.execute(100)
  end
end

Main.main()
