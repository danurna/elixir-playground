defmodule MultiDict do 
  def new(), do: %{}

  def add(dict, key, value) do 
    Map.update(dict, key, [value], &[value | &1])
  end

  def get(dict, key) do 
    Map.get(dict, key, [])
  end 

end


defmodule TodoList do 
  def new(), do: MultiDict.new()

  def add_entry(todo_list, date, title) do 
    MultiDict.add(todo_list, date, title)
  end 

  def entries(todo_list, date) do
    MultiDict.get(todo_list, date)
  end

end

ExUnit.start

defmodule TodoListTests do
  use ExUnit.Case

  test "Item added can be retrieved" do 
    todo_list = TodoList.new() 
        |> TodoList.add_entry(~D[2018-01-01], "Say hi")
    assert TodoList.entries(todo_list, ~D[2018-01-01]) == ["Say hi"]
  end 
  
  test "Multiple items added can be retrieved" do 
    todo_list = TodoList.new() 
        |> TodoList.add_entry(~D[2018-01-01], "Say hi")
        |> TodoList.add_entry(~D[2018-01-01], "Say hi again")
    assert TodoList.entries(todo_list, ~D[2018-01-01]) == ["Say hi again", "Say hi"]
  end 
end

