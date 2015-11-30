defmodule Reversi.Board do

  defstruct mapping: %{}

  @cols ~w[a b c d e f g h]
  @rows ~w[1 2 3 4 5 6 7 8]

  def new do
    mapping = for col <- @cols, row <- @rows, into: %{} do
      {coords(col, row), :empty}
    end

    %__MODULE__{mapping: mapping}
  end

  def coords(col, row), do: {col, row}

  def put(board, coords = {col, row}, color)
  when col in @cols and row in @rows and color in [:black, :white] do
    new_mapping = Map.put(board.mapping, coords, color)
    %__MODULE__{board | mapping: new_mapping}
  end

  def get(board, coords) do
    Map.get(board.mapping, coords)
  end

  def empty?(board, coords) do
    get(board, coords) == :empty
  end

  def to_string(board) do
    header = "   " <> Enum.join(@cols, " ")
    Enum.reduce @rows, header, fn row, lines ->
      line = Enum.reduce @cols, "", fn col, acc ->
        case get(board, coords(col, row)) do
          :black -> acc <> "●"
          :white -> acc <> "○"
          :empty -> acc <> "  "
        end
      end
      "#{lines}\n#{row} #{line}"
    end
  end
end
