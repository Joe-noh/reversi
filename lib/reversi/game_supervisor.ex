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

  def start_game do
    uuid = generate_uuid
    Supervisor.start_child(@name, [[uuid: uuid]])

    uuid
  end

  @doc """
  TODO: guarantee uniqueness
  """
  defp generate_uuid do
    ?a..?z |> Enum.take_random(10) |> List.to_string
  end
end
