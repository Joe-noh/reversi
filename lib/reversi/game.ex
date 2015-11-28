defmodule Reversi.Game do
  use GenServer

  alias Reversi.NameResolver

  defstruct [:uuid]

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(uuid: uuid) do
    Reversi.NameResolver.register(uuid, self)

    {:ok, %__MODULE__{uuid: uuid}}
  end

  def put(uuid, color, col, row) do
    NameResolver.whereis(uuid)
    |> GenServer.cast {:put, color, col, row}
  end

  def handle_cast({:put, color, col, row}, state) do
    IO.inspect "a chip is put"

    {:noreply, state}
  end
end
