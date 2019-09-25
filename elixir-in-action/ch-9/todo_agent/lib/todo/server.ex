defmodule Todo.Server do 
  use Agent, restart: :temporary
  
  def start_link(list_name) do
    Agent.start_link(
      fn -> 
        IO.puts("Starting server for #{list_name}")
        {list_name, Todo.Database.get(list_name) || Todo.List.new()}
      end,
      name: via_tuple(list_name)
    )
  end
  
  defp via_tuple(id) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, id})
  end
  
  def add_entry(server_pid, new_entry) do
    Agent.cast(server_pid, fn {name, todo_list} ->
      new_list = Todo.List.add_entry(todo_list, new_entry)
      Todo.Database.store(name, new_list)
      {name, new_list}
    end)
  end

  def entries(server_pid, date) do 
    Agent.get(
      server_pid, 
      fn {_name, todo_list} -> Todo.List.entries(todo_list, date) end
    )
  end
end 

