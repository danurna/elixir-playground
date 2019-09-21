defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"
  @pool_size 3

  def start do 
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

defmodule Todo.DatabaseWorker do 
  use GenServer

  def start(db_folder) do 
    GenServer.start(__MODULE__, db_folder)
  end

  def store(worker, key, data) do 
    GenServer.cast(worker, {:store, key, data})
  end

  def get(worker, key) do 
    GenServer.call(worker, {:get, key})
  end

  @impl GenServer
  def init(db_folder) do
    {:ok, db_folder}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, db_folder) do
    key
    |> file_name(db_folder)
    |> File.write!(:erlang.term_to_binary(data))
    
    {:noreply, db_folder} 
  end
  
  @impl GenServer
  def handle_call({:get, key}, _, db_folder) do
    raw_data = key 
      |> file_name(db_folder)
      |> File.read()

    data = case raw_data do
      {:ok, contents} -> :erlang.binary_to_term(contents) 
      _ -> nil
    end

    {:reply, data, db_folder} 
  end

  defp file_name(key, db_folder) do
    Path.join(db_folder, to_string(key))
  end
end

