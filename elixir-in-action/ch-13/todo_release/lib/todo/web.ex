defmodule Todo.Web do
  use Plug.Router

  plug :match
  plug :dispatch

  def child_spec(_arg) do 
    Plug.Adapters.Cowboy.child_spec(
      scheme: :http,
      options: [port: Application.fetch_env!(:todo, :port)],
      plug: __MODULE__
    )
  end

  # curl -d "" http://192.168.1.112:5454/add_entry\?list\=sophie\&date\=2018-12-20\&title\=Yolo
  post "/add_entry" do 
    conn = Plug.Conn.fetch_query_params(conn)
    list_name = Map.fetch!(conn.params, "list")
    title = Map.fetch!(conn.params, "title")
    date = Date.from_iso8601!(Map.fetch!(conn.params, "date"))

    list_name
    |> Todo.Cache.server_process()
    |> Todo.Server.add_entry(%{title: title, date: date})

    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, "OK")
  end

  # curl http://192.168.1.112:5454/entries\?list\=sophie\&date\=2018-12-20
  get "/entries" do
    conn = Plug.Conn.fetch_query_params(conn)
    list_name = Map.fetch!(conn.params, "list")
    date = Date.from_iso8601!(Map.fetch!(conn.params, "date"))

    entries = 
      list_name
      |> Todo.Cache.server_process()
      |> Todo.Server.entries(date)

    formatted_entries =
      entries
      |> Enum.map(&"#{&1.date} #{&1.title}")
      |> Enum.join("\n")

    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, formatted_entries)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
