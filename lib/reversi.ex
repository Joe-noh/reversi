defmodule Reversi do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Reversi.NameResolver, []),
      worker(Reversi.GameSup, [])
    ]

    opts = [strategy: :one_for_one, name: Reversi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
