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

  def add_entry(todo_list, entry) do 
    MultiDict.add(todo_list, entry.date, entry)
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
        |> TodoList.add_entry(%{date: ~D[2018-01-01], title: "Say hi"})
    assert TodoList.entries(todo_list, ~D[2018-01-01]) == [%{date: ~D[2018-01-01], title: "Say hi"}]
  end 
  
  test "Multiple items added can be retrieved" do 
    todo_list = TodoList.new() 
        |> TodoList.add_entry(%{date: ~D[2018-01-01], title: "Say hi"})
        |> TodoList.add_entry(%{date: ~D[2018-01-01], title: "Say hi again"})
    assert TodoList.entries(todo_list, ~D[2018-01-01]) == [
      %{date: ~D[2018-01-01], title: "Say hi again"}, 
      %{date: ~D[2018-01-01], title: "Say hi"}
    ]
  end 
end

