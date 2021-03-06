defmodule Todo.Cache do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def server_process(todo_cache, todo_list_name) do 
    GenServer.call(todo_cache, {:server_process, todo_list_name}) 
  end

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:server_process, todo_list_name}, _, todo_servers) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, server} -> 
        {:reply, server, todo_servers}
      
      :error -> 
        {:ok, new_server} = Todo.Server.start()
        todo_servers = Map.put(todo_servers, todo_list_name, new_server)
        
        {
          :reply, 
          new_server,
          todo_servers
        }
    end
  end
end 
