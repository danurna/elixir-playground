defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"
  @pool_size 3

  def start_link(_) do 
    IO.puts("Starting database server")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do 
    key 
    |> worker_id()
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do 
    key
    |> worker_id()
    |> Todo.DatabaseWorker.get(key)
  end

  defp worker_id(key) do
    :erlang.phash2(key, @pool_size)
  end

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)
    start_workers()
    {:ok, nil}
  end

  defp start_workers() do
    for index <- 0..@pool_size-1 do
      Todo.DatabaseWorker.start_link(@db_folder, index)
    end
  end

end
