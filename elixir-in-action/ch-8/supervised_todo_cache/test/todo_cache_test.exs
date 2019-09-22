defmodule TodoCacheTest do 
  use ExUnit.Case

  test "server_process" do 
    {:ok, _} = Todo.Cache.start_link(nil)
    bob_pid = Todo.Cache.server_process("bob")

    assert bob_pid != Todo.Cache.server_process("alice")
    assert bob_pid == Todo.Cache.server_process("bob")
  end
end
