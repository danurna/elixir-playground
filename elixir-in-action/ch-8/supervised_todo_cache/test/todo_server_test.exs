defmodule TodoServerTests do
  use ExUnit.Case

  setup_all do
    {:ok, pid} = Todo.Database.start()
    {:ok, database_pid: pid}
  end

  test "Write and read from server" do
    {:ok, server_id} = Todo.Server.start("Alice List")
    Todo.Server.add_entry(server_id, %{date: ~D[2018-01-01], title: "Alpha"})
    entries = Todo.Server.entries(server_id, ~D[2018-01-01]) 

    assert [%{date: ~D[2018-01-01], id: 1, title: "Alpha"}] = entries
  end
end
