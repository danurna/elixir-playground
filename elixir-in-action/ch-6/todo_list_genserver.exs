defmodule TodoServer do 
  use GenServer

  @impl GenServer
  def init(_) do
    {:ok, TodoList.new()}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, todo_list) do
    {:reply, TodoList.entries(todo_list, date), todo_list}
  end

  @impl GenServer
  def handle_cast({:add_entry, entry}, todo_list) do
    {:noreply, TodoList.add_entry(todo_list, entry)}
  end

  # --- Interaction
  def start() do
    GenServer.start(__MODULE__, nil)
  end
  
  def add_entry(todo_server, entry) do
    GenServer.cast(todo_server, {:add_entry, entry})
  end

  def entries(todo_server, date) do 
    GenServer.call(todo_server, {:entries, date})
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

ExUnit.start

defmodule TodoListTests do
  use ExUnit.Case

  test "Write and read from server" do
    {:ok, server_id} = TodoServer.start()
    TodoServer.add_entry(server_id, %{date: ~D[2018-01-01], title: "Alpha"})
    assert TodoServer.entries(server_id, ~D[2018-01-01]) == [ 
     %{date: ~D[2018-01-01], id: 1, title: "Alpha"}
    ]
  end
end
