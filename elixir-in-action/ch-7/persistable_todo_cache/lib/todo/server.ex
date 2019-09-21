defmodule Todo.Server do 
  use GenServer

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
  def start(list_name) do
    GenServer.start(__MODULE__, list_name)
  end
  
  def add_entry(todo_server, entry) do
    GenServer.cast(todo_server, {:add_entry, entry})
  end

  def entries(todo_server, date) do 
    GenServer.call(todo_server, {:entries, date})
  end
end 

