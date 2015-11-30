defmodule Reversi.Game do
  use GenServer

  alias Reversi.NameResolver
  alias Reversi.Board

  defstruct [uuid: nil, board: Board.new]

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(uuid: uuid) do
    NameResolver.register(uuid, self)

    {:ok, %__MODULE__{uuid: uuid}}
  end

  def put(uuid, color, col, row) do
    NameResolver.whereis(uuid)
    |> GenServer.cast({:put, color, col, row})
  end

  def display_board(uuid) do
    NameResolver.whereis(uuid)
    |> GenServer.call(:to_string)
    |> IO.puts
  end

  def handle_cast({:put, color, col, row}, state) do
    IO.inspect "a chip is put"

    {:noreply, state}
  end

  def handle_call(:to_string, _from, state) do
    Enum.state.board
  end
end
