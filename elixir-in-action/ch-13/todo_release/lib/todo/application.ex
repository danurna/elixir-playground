defmodule Todo.Application do
  use Application

  def start(_type, _args) do
    children = [
      Todo.Database,
      Todo.Cache,
      Todo.Web
    ]
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
