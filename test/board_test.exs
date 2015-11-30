defmodule BoardTest do
  use ExUnit.Case

  alias Reversi.Board

  setup do
    {:ok, board: Board.new}
  end

  test "new/0 returns initialized board", %{board: board} do
    init_black = [Board.coords("d", "4"), Board.coords("e", "5")]
    init_white = [Board.coords("d", "5"), Board.coords("e", "4")]

    Enum.each board.mapping, fn
      {coords, :black} -> assert coords in init_black
      {coords, :white} -> assert coords in init_white
      {coords, _color} -> assert Board.empty?(board, coords)
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

  test "to_string/1", %{board: board} do
    expected = Enum.join [
      "   a b c d e f g h",
      "1                 ",
      "2                 ",
      "3                 ",
      "4       ●○      ",
      "5       ○●      ",
      "6                 ",
      "7                 ",
      "8                 "
    ], "\n"

    assert Board.to_string(board) == expected

    board = board
      |> Board.put(Board.coords("c", "1"), :white)
      |> Board.put(Board.coords("b", "8"), :black)
    expected = Enum.join [
      "   a b c d e f g h",
      "1     ○          ",
      "2                 ",
      "3                 ",
      "4       ●○      ",
      "5       ○●      ",
      "6                 ",
      "7                 ",
      "8   ●            "
    ], "\n"

    assert Board.to_string(board) == expected
  end
end
