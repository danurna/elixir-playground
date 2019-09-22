defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"
  @pool_size 3

  def start do 
    IO.puts("Starting database server")
    GenServer.start(__MODULE__, nil,
      name: __MODULE__
    )
  end

  def store(key, data) do 
    key 
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do 
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end

  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, start_workers()}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _, workers) do
    worker_key = :erlang.phash2(key, @pool_size)
    {:reply, Map.get(workers, worker_key), workers} 
  end

  defp start_workers() do
    Enum.reduce(
      0..@pool_size-1,
      %{},
      fn index, acc ->
        {:ok, worker_pid} = Todo.DatabaseWorker.start(@db_folder) 
        Map.put(acc, index, worker_pid)
      end
    )
  end
end
