defmodule Reversi.Game do
  use GenServer

  alias Reversi.NameResolver
  alias Reversi.Board

  defstruct [uuid: nil, board: Board.new, current_color: :black]

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(uuid: uuid) do
    NameResolver.register(uuid, self)

    {:ok, %__MODULE__{uuid: uuid}}
  end

  def put(uuid, col, row, "○"), do: put(uuid, col, row, :white)
  def put(uuid, col, row, "×"), do: put(uuid, col, row, :black)

  def put(uuid, col, row, color) do
    NameResolver.whereis(uuid)
    |> GenServer.call({:put, col, row, color})
  end

  def current_color(uuid) do
    NameResolver.whereis(uuid)
    |> GenServer.call(:current_color)
  end

  def display_board(uuid) do
    NameResolver.whereis(uuid)
    |> GenServer.call(:to_string)
    |> IO.puts
  end

  def handle_call({:put, col, row, color}, _from, state = %{current_color: color}) do
    new_board = Board.put(state.board, Board.coords(col, row), color)
    {:reply, :ok, %__MODULE__{state | board: new_board, current_color: next_color(color)}}
  end

  def handle_call({:put, _col, _row, _color}, _from, state) do
    {:reply, {:error, "not your turn"}, state}
  end

  def handle_call(:current_color, _from, %{current_color: color} = state) do
    {:reply, color, state}
  end

  def handle_call(:to_string, _from, state) do
    {:reply, Board.to_string(state.board), state}
  end

  defp next_color(:white), do: :black
  defp next_color(:black), do: :white
end
