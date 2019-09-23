defmodule TodoServerTests do
  use ExUnit.Case

  setup_all do
    Todo.System.start_link()
    {:ok, context: nil}
  end

  test "Write and read from server" do
    {:ok, server_id} = Todo.Server.start_link("AliceList")
    Todo.Server.add_entry(server_id, %{date: ~D[2018-01-01], title: "Alpha"})
    entries = Todo.Server.entries(server_id, ~D[2018-01-01]) 

    assert [%{date: ~D[2018-01-01], id: 1, title: "Alpha"}] = entries
  end

  test "Read from persisted list" do
    expected_entry = %{date: ~D[2018-01-01], title: "Alpha"} 
    list = Todo.List.new([expected_entry])
    File.write!("./persist/alice", :erlang.term_to_binary(list))

    {:ok, server_id} = Todo.Server.start_link("alice")
    entries = Todo.Server.entries(server_id, ~D[2018-01-01]) 
    assert [%{date: ~D[2018-01-01], id: 1, title: "Alpha"}] = entries
  end
end
