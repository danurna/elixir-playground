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

  def update_entry(todo_list, entry_id, updater_fun) do 
    case Map.fetch(todo_list.entries, entry_id) do
      :error -> 
        todo_list
      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry) 
        %TodoList{todo_list | entries: new_entries}
    end
  end 

  def delete_entry(todo_list, entry_id) do 
    new_entries = Map.delete(todo_list.entries, entry_id)
    %TodoList{todo_list | entries: new_entries}
  end
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
  
  test "Item is updated" do
    todo_list = TodoList.new() 
        |> TodoList.add_entry(%{date: ~D[2018-01-01], title: "Say hi"})
        |> TodoList.update_entry(1, &Map.put(&1, :title, "Say bye"))
    assert TodoList.entries(todo_list, ~D[2018-01-01]) == [%{date: ~D[2018-01-01], id: 1, title: "Say bye"}]
  end 
  
  test "Item update modifiying ID produces an error" do
    todo_list = TodoList.new() 
        |> TodoList.add_entry(%{date: ~D[2018-01-01], title: "Say hi"})
    assert_raise MatchError, fn ->
      TodoList.update_entry(todo_list, 1, &Map.put(&1, :id, 3))
    end
  end 

  test "Item added can be deleted" do 
    todo_list = TodoList.new() 
        |> TodoList.add_entry(%{date: ~D[2018-01-01], title: "Say hi"})
        |> TodoList.add_entry(%{date: ~D[2018-01-01], title: "Say hi again"})
        |> TodoList.delete_entry(2)
    assert TodoList.entries(todo_list, ~D[2018-01-01]) == [%{date: ~D[2018-01-01], id: 1, title: "Say hi"}]
  end 
end

