defmodule LineHelper do 
  def large_lines!(path) do 
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.filter(&(String.length(&1) > 10))
  end

  def lines_length!(path) do  
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.length(&1))
    |> Enum.to_list() 
  end

  def longest_line_length!(path) do  
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.length(&1))
    |> Enum.reduce(0, 
    fn
      length, longestLength when length > longestLength -> 
       length 

      _, longestLength -> longestLength
    end)
  end

  def longest_line!(path) do  
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&{&1, String.length(&1)})
    |> Enum.reduce("", 
    fn {line, lineLength}, longestLine -> 
      if lineLength > String.length(longestLine) do
        line
      else
        longestLine
      end
    end)
  end 

  def words_per_line!(path) do  
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&length(String.split(&1))) 
    |> Enum.to_list() 
  end
end
