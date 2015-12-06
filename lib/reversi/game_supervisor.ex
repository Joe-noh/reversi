defmodule Reversi.GameSup do
  use Supervisor

  @name __MODULE__

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    children = [
      worker(Reversi.Game, [])
    ]
    opts = [strategy: :simple_one_for_one]

    supervise(children, opts)
  end

  @spec start_game :: String.t
  def start_game do
    uuid = Reversi.UUID.get
    Supervisor.start_child(@name, [[uuid: uuid]])

    uuid
  end
end
