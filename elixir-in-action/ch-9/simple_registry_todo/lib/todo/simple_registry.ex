defmodule SimpleRegistry do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: :simple_registry)
  end

  def register(name) do
     GenServer.call(:simple_registry, {:register, name, self()})
  end

  def whereis(name) do 
    case lookup(name) do
      {:ok, pid} -> pid
      :error -> nil
    end
  end
  
  defp lookup(name) do
    case :ets.lookup(__MODULE__, name) do
      [{^name, pid}] -> {:ok, pid}
      [] -> :error
    end
  end

  @impl GenServer
  def init(_) do
    :ets.new(__MODULE__, [:named_table, :public, write_concurrency: true])
    {:ok, nil}
  end

  @impl GenServer
  def handle_call({:register, key, pid}, _, registry) do
    case lookup(key) do
      {:ok, _} -> {:reply, :error, registry}
      :error -> 
        :ets.insert(__MODULE__, {key, pid})
        {:reply, :ok, registry} 
    end
  end
end
