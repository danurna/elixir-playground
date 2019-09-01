defmodule TodoList do 
  def new(), do: %{}

  def add_entry(todo_list, date, title) do 
    Map.update(todo_list, date, [title], &([title | &1]))
  end 

  def entries(todo_list, date) do
    Map.get(todo_list, date, [])
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

