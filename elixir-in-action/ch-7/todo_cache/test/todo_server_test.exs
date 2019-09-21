defmodule TodoServerTests do
  use ExUnit.Case

  test "Write and read from server" do
    {:ok, server_id} = Todo.Server.start()
    Todo.Server.add_entry(server_id, %{date: ~D[2018-01-01], title: "Alpha"})
    assert Todo.Server.entries(server_id, ~D[2018-01-01]) == [ 
     %{date: ~D[2018-01-01], id: 1, title: "Alpha"}
    ]
  end
end
