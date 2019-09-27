defmodule SimpleRegistry do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: :simple_registry)
  end

  def register(name) do
     GenServer.call(:simple_registry, {:register, name, self()})
  end

  def whereis(name) do 
    GenServer.call(:simple_registry, {:whereis, name})
  end

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:register, name, pid}, _, registry) do
    case Map.fetch(registry, name) do
      {:ok, _} -> {:reply, :error, registry}
      :error -> 
        new_registry = Map.put(registry, name, pid) 
        {:reply, :ok, new_registry} 
    end
  end

  @impl GenServer
  def handle_call({:whereis, name}, _, registry) do
    {:reply, registry[name], registry}
  end
end
