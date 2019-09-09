defmodule TodoServer do 
  def init() do
    TodoList.new()
  end

  def handle_call({:entries, date}, todo_list) do
    {TodoList.entries(todo_list, date), todo_list}
  end

  def handle_cast({:add_entry, entry}, todo_list) do
    TodoList.add_entry(todo_list, entry)
  end

  # --- Interaction
  def start() do
    ServerProcess.start(__MODULE__)
  end
  
  def add_entry(todo_server, entry) do 
    ServerProcess.cast(todo_server, {:add_entry, entry})
  end

  def entries(todo_server, date) do 
    ServerProcess.call(todo_server, {:entries, date})
  end
end 

defmodule TodoList do
  defstruct auto_id: 1, entries: %{}
  
  def new(entries \\ []) do 
    Enum.reduce(
      entries,
      %TodoList{},
      fn entry, todo_list_acc -> 
        add_entry(todo_list_acc, entry)
      end
    )
  end

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


defmodule ServerProcess do
  def start(callback_module) do 
    spawn(fn ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)
  end

  defp loop(callback_module, current_state) do
    receive do
      {:call, request, caller} -> 
        {response, new_state} =
          callback_module.handle_call(
            request,
            current_state
          )

        send(caller, {:response, response})

        loop(callback_module, new_state)
      {:cast, request} ->
        new_state =
          callback_module.handle_cast(
            request,
            current_state
          )

        loop(callback_module, new_state)
    end
  end

  def call(server_id, request) do 
    send(server_id, {:call, request, self()})

    receive do 
      {:response, response} -> 
        response
    end
  end

  def cast(server_id, request) do 
    send(server_id, {:cast, request})
  end
end

ExUnit.start

defmodule TodoListTests do
  use ExUnit.Case

  test "Write and read from server" do
    server_id = TodoServer.start()
    TodoServer.add_entry(server_id, %{date: ~D[2018-01-01], title: "Alpha"})
    assert TodoServer.entries(server_id, ~D[2018-01-01]) == [ 
     %{date: ~D[2018-01-01], id: 1, title: "Alpha"}
    ]
  end
end
