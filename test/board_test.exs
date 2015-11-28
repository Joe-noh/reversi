defmodule BoardTest do
  use ExUnit.Case

  alias Reversi.Board

  setup do
    {:ok, board: Board.new}
  end

  test "new/0 returns empty board", %{board: board} do
    Enum.each board.mapping, fn {coords, _} ->
      assert Board.empty?(board, coords)
    end
  end

  test "put/3 places a chip on the board", %{board: board} do
    coords = Board.coords("a", "1")

    assert Board.put(board, coords, :white) |> Board.get(coords) == :white
  end

  test "put/3 accepts only :white or :black", %{board: board} do
    coords = Board.coords("a", "1")

    assert_raise FunctionClauseError, fn -> Board.put(board, coords, :another) end
  end
end
