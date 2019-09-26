defmodule TodoServerTests do
  use ExUnit.Case

  setup_all do
    Todo.System.start_link()
    {:ok, context: nil}
  end

  test "Write and read from server" do
    {:ok, pid} = Todo.Server.start_link("AliceList")
    Todo.Server.add_entry(pid, %{date: ~D[2018-01-01], title: "Alpha"})
    entries = Todo.Server.entries(pid, ~D[2018-01-01]) 

    assert [%{date: ~D[2018-01-01], id: 1, title: "Alpha"}] = entries
  end

  test "Read from persisted list" do
    expected_entry = %{date: ~D[2018-01-01], title: "Alpha"} 
    list = Todo.List.new([expected_entry])
    File.write!("./persist/alice", :erlang.term_to_binary(list))

    {:ok, pid} = Todo.Server.start_link("alice")
    entries = Todo.Server.entries(pid, ~D[2018-01-01]) 
    assert [%{date: ~D[2018-01-01], id: 1, title: "Alpha"}] = entries
  end
end
