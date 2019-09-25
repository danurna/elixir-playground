defmodule TodoCacheTest do 
  use ExUnit.Case
  
  setup_all do
    Todo.System.start_link()
    {:ok, context: nil}
  end

  test "server_process" do 
    bob_pid = Todo.Cache.server_process("bob")

    assert bob_pid != Todo.Cache.server_process("alice")
    assert bob_pid == Todo.Cache.server_process("bob")
  end
end
