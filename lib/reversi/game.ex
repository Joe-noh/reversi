defmodule Reversi.Game do
  use GenServer

  alias Reversi.NameResolver
  alias Reversi.Board

  defstruct [uuid: nil, board: Board.new, next_color: :black]

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(uuid: uuid) do
    NameResolver.register(uuid, self)

    {:ok, %__MODULE__{uuid: uuid}}
  end

  def put(uuid, col, row, color) do
    NameResolver.whereis(uuid)
    |> GenServer.call({:put, col, row, color})
  end

  def display_board(uuid) do
    NameResolver.whereis(uuid)
    |> GenServer.call(:to_string)
    |> IO.puts
  end

  def handle_call({:put, col, row, color}, _from, state = %{next_color: color}) do
    new_board = Board.put(state.board, Board.coords(col, row), color)
    {:reply, :ok, %__MODULE__{state | board: new_board, next_color: next_color(color)}}
  end

  def handle_call({:put, col, row, color}, _from, state) do
    {:reply, {:error, "not your turn"}, state}
  end

  def handle_call(:to_string, _from, state) do
    Enum.state.board
  end

  defp next_color(:white), do: :black
  defp next_color(:black), do: :white
end
