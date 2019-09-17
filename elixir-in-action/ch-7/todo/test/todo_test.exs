defmodule TodoServerTests do
  use ExUnit.Case

  test "Write and read from server" do
    {:ok, server_id} = Todo.Server.start()
    Todo.Server.add_entry(server_id, %{date: ~D[2018-01-01], title: "Alpha"})
    assert Todo.Server.entries(server_id, ~D[2018-01-01]) == [ 
     %{date: ~D[2018-01-01], id: 1, title: "Alpha"}
    ]
  end
end

defmodule TodoListTests do
  use ExUnit.Case

  test "Create list from enumerable" do
    entries = [
      %{date: ~D[2018-01-01], title: "Alpha"},
      %{date: ~D[2018-01-01], title: "Gamma"}
    ]
    todo_list = Todo.List.new(entries)
    assert Todo.List.entries(todo_list, ~D[2018-01-01]) == [
      %{date: ~D[2018-01-01], id: 1, title: "Alpha"},
      %{date: ~D[2018-01-01], id: 2, title: "Gamma"}
    ]
  end

  test "Item added can be retrieved" do 
    todo_list = Todo.List.new() 
        |> Todo.List.add_entry(%{date: ~D[2018-01-01], title: "Say hi"})
    assert Todo.List.entries(todo_list, ~D[2018-01-01]) == [%{date: ~D[2018-01-01], id: 1, title: "Say hi"}]
  end 

  test "Multiple items added can be retrieved" do 
    todo_list = Todo.List.new() 
        |> Todo.List.add_entry(%{date: ~D[2018-01-01], title: "Say hi"})
        |> Todo.List.add_entry(%{date: ~D[2018-01-02], title: "Say hi again"})
        |> Todo.List.add_entry(%{date: ~D[2018-01-01], title: "Don't say hi"})
    assert Todo.List.entries(todo_list, ~D[2018-01-01]) == [
      %{date: ~D[2018-01-01], id: 1, title: "Say hi"},
      %{date: ~D[2018-01-01], id: 3, title: "Don't say hi"}
    ]
  end 
  
  test "Item is updated" do
    todo_list = Todo.List.new() 
        |> Todo.List.add_entry(%{date: ~D[2018-01-01], title: "Say hi"})
        |> Todo.List.update_entry(1, &Map.put(&1, :title, "Say bye"))
    assert Todo.List.entries(todo_list, ~D[2018-01-01]) == [%{date: ~D[2018-01-01], id: 1, title: "Say bye"}]
  end 
  
  test "Item update modifiying ID produces an error" do
    todo_list = Todo.List.new() 
        |> Todo.List.add_entry(%{date: ~D[2018-01-01], title: "Say hi"})
    assert_raise MatchError, fn ->
      Todo.List.update_entry(todo_list, 1, &Map.put(&1, :id, 3))
    end
  end 

  test "Item added can be deleted" do 
    todo_list = Todo.List.new() 
        |> Todo.List.add_entry(%{date: ~D[2018-01-01], title: "Say hi"})
        |> Todo.List.add_entry(%{date: ~D[2018-01-01], title: "Say hi again"})
        |> Todo.List.delete_entry(2)
    assert Todo.List.entries(todo_list, ~D[2018-01-01]) == [%{date: ~D[2018-01-01], id: 1, title: "Say hi"}]
  end 
end
