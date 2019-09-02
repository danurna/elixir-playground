defmodule TodoList do
  defstruct auto_id: 1, entries: %{}
  
  def new(), do: %TodoList{}

  def add_entry(todo_list, entry) do 
    entry = Map.put(entry, :id, todo_list.auto_id)
    new_entries = Map.put(
      todo_list.entries,
      todo_list.auto_id,
      entry
    )

    %TodoList{todo_list |
      entries: new_entries,
      auto_id: todo_list.auto_id + 1
    }
  end 

  def entries(todo_list, date) do
    todo_list.entries
      |> Stream.filter(fn {_, entry} -> entry.date == date end)
      |> Enum.map(fn {_, entry} -> entry end)
  end

  #def update_entry(todo_list, 
end

ExUnit.start

defmodule TodoListTests do
  use ExUnit.Case

  test "Item added can be retrieved" do 
    todo_list = TodoList.new() 
        |> TodoList.add_entry(%{date: ~D[2018-01-01], title: "Say hi"})
    assert TodoList.entries(todo_list, ~D[2018-01-01]) == [%{date: ~D[2018-01-01], id: 1, title: "Say hi"}]
  end 

  test "Multiple items added can be retrieved" do 
    todo_list = TodoList.new() 
        |> TodoList.add_entry(%{date: ~D[2018-01-01], title: "Say hi"})
        |> TodoList.add_entry(%{date: ~D[2018-01-02], title: "Say hi again"})
        |> TodoList.add_entry(%{date: ~D[2018-01-01], title: "Don't say hi"})
    assert TodoList.entries(todo_list, ~D[2018-01-01]) == [
      %{date: ~D[2018-01-01], id: 1, title: "Say hi"},
      %{date: ~D[2018-01-01], id: 3, title: "Don't say hi"}
    ]
  end 
end

