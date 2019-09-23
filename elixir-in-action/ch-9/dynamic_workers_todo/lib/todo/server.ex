defmodule Todo.Server do 
  use GenServer, restart: :temporary

  @impl GenServer
  def init(name) do
    {:ok, {name, Todo.Database.get(name) || Todo.List.new()}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, {name, list}) do
    {:reply, Todo.List.entries(list, date), {name, list}}
  end

  @impl GenServer
  def handle_cast({:add_entry, entry}, {name, list}) do
    updated_list = Todo.List.add_entry(list, entry)  
    Todo.Database.store(name, list) 
    {:noreply, {name, updated_list}}
  end

  # --- Interaction
  def start_link(list_name) do
    IO.puts("Starting server for #{list_name}")
    GenServer.start_link(__MODULE__, list_name, name: via_tuple(list_name))
  end
  
  defp via_tuple(id) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, id})
  end
  
  def add_entry(list_name, entry) do
    GenServer.cast(via_tuple(list_name), {:add_entry, entry})
  end

  def entries(list_name, date) do 
    GenServer.call(via_tuple(list_name), {:entries, date})
  end
end 

