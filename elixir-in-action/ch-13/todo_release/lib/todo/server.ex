defmodule Todo.Server do 
  use GenServer, restart: :temporary

  @impl GenServer
  def init(name) do
    IO.puts("Starting server for #{name}")
    {
      :ok, 
      {name, Todo.Database.get(name) || Todo.List.new()}
    }
  end

  @impl GenServer
  def handle_call({:entries, date}, _, {name, list}) do
    {:reply, Todo.List.entries(list, date), {name, list}}
  end

  @impl GenServer
  def handle_cast({:add_entry, entry}, {name, list}) do
    updated_list = Todo.List.add_entry(list, entry)  
    Todo.Database.store(name, updated_list) 
    {:noreply, {name, updated_list}}
  end
    
  @impl GenServer
  def handle_info(:timeout, {name, todo_list}) do
    IO.puts("Stopping to-do server for #{name}")
    {:stop, :normal, {name, todo_list}}
  end

  # --- Interaction
  def start_link(list_name) do
    GenServer.start_link(__MODULE__, list_name, name: global_name(list_name)) 
  end

  def whereis(list_name) do 
    case :global.whereis_name({__MODULE__, list_name}) do
      :undefined -> nil
      pid -> pid
    end
  end

  defp global_name(name) do
    {:global, {__MODULE__, name}}
  end
  
  def add_entry(server_pid, entry) do
    GenServer.cast(server_pid, {:add_entry, entry})
  end

  def entries(server_pid, date) do 
    GenServer.call(server_pid, {:entries, date})
  end
end 

