defmodule Reversi.Game do
  use GenServer

  alias Reversi.NameResolver
  alias Reversi.Board

  defstruct [uuid: nil, board: Board.new, current_color: :black]

  @type t :: %__MODULE__{uuid: String.t, board: Board.t, current_color: :black | :white}

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(uuid: uuid) do
    NameResolver.register(uuid, self)

    {:ok, %__MODULE__{uuid: uuid}}
  end

  @spec put(String.t, String.t, String.t, String.t | atom) :: :ok
  def put(uuid, col, row, "○"), do: put(uuid, col, row, :white)
  def put(uuid, col, row, "×"), do: put(uuid, col, row, :black)

  def put(uuid, col, row, color) do
    NameResolver.whereis(uuid)
    |> GenServer.call({:put, col, row, color})
  end

  @spec current_color(String.t) :: atom
  def current_color(uuid) do
    NameResolver.whereis(uuid)
    |> GenServer.call(:current_color)
  end

  @spec display_board(String.t) :: :ok
  def display_board(uuid) do
    NameResolver.whereis(uuid)
    |> GenServer.call(:to_string)
    |> IO.puts
  end

  def handle_call({:put, col, row, color}, _from, state = %{board: board, current_color: color}) do
    new_board = Board.put(board, Board.coords(col, row), color)
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

  @spec next_color(:white | :black) :: :black | :white
  defp next_color(:white), do: :black
  defp next_color(:black), do: :white
end
