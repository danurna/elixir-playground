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
  
  def add_entry(server_pid, entry) do
    GenServer.cast(server_pid, {:add_entry, entry})
  end

  def entries(server_pid, date) do 
    GenServer.call(server_pid, {:entries, date})
  end
end 

