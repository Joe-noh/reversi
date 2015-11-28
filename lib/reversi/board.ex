defmodule Reversi.Board do

  defstruct mapping: %{}

  @cols ~w[a b c d e f g h]
  @rows ~w[1 2 3 4 5 6 7 8]

  def new do
    mapping = for col <- @cols, row <- @rows, into: %{} do
      {coords(col, row), @empty}
    end

    %__MODULE__{mapping: mapping}
  end

  def coords(col, row), do: {col, row}

  def put(board, coords, color) when tuple_size(coords) == 2 and color in [:black, :white] do
    new_mapping = Map.put(board.mapping, coords, color)
    %__MODULE__{board | mapping: new_mapping}
  end

  def get(board, coords) do
    Map.get(board.mapping, coords)
  end

  def empty?(board, coords) do
    get(board, coords) == @empty
  end
end
