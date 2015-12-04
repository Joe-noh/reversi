defmodule GameTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Reversi.Game

  setup do
    {:ok, game_id: Reversi.GameSup.start_game}
  end

  test "put disks by turns", %{game_id: game_id} do
    assert Game.put(game_id, "c", "5", :black) == :ok
    assert Game.put(game_id, "e", "6", :white) == :ok
  end

  test "returns error when wrong disk is being put", %{game_id: game_id} do
    assert Game.put(game_id, "c", "5", :black) == :ok
    assert {:error, _} = Game.put(game_id, "d", "6", :black)
  end

  test "current_color returns the color of disk which is going to be put", %{game_id: game_id} do
    assert Game.current_color(game_id) == :black

    Game.put(game_id, "c", "5", :black)

    assert Game.current_color(game_id) == :white
  end

  test "put accepts the string", %{game_id: game_id} do
    assert Game.put(game_id, "c", "5", "×")
    assert Game.put(game_id, "c", "5", "○")
  end

  test "integratonal", %{game_id: game_id} do
    Game.put(game_id, "f", "5", :black)
    Game.put(game_id, "d", "6", :white)
    Game.put(game_id, "c", "3", :black)
    Game.put(game_id, "d", "3", :white)
    Game.put(game_id, "c", "4", :black)
    Game.put(game_id, "f", "4", :white)
    Game.put(game_id, "c", "5", :black)
    Game.put(game_id, "b", "3", :white)
    Game.put(game_id, "c", "2", :black)
    Game.put(game_id, "e", "6", :white)
    Game.put(game_id, "c", "6", :black)
    Game.put(game_id, "b", "4", :white)
    Game.put(game_id, "b", "5", :black)
    Game.put(game_id, "d", "2", :white)
    Game.put(game_id, "e", "3", :black)
    Game.put(game_id, "a", "6", :white)
    Game.put(game_id, "c", "1", :black)
    Game.put(game_id, "b", "6", :white)
    Game.put(game_id, "f", "3", :black)
    Game.put(game_id, "f", "6", :white)
    Game.put(game_id, "f", "7", :black)
    Game.put(game_id, "g", "5", :white)
    Game.put(game_id, "d", "7", :black)
    Game.put(game_id, "c", "7", :white)
    Game.put(game_id, "g", "4", :black)
    Game.put(game_id, "e", "1", :white)
    Game.put(game_id, "d", "1", :black)
    Game.put(game_id, "b", "1", :white)
    Game.put(game_id, "e", "7", :black)
    Game.put(game_id, "e", "2", :white)
    Game.put(game_id, "a", "5", :black)
    Game.put(game_id, "a", "4", :white)
    Game.put(game_id, "b", "8", :black)
    Game.put(game_id, "f", "8", :white)
    Game.put(game_id, "e", "8", :black)
    Game.put(game_id, "c", "8", :white)
    Game.put(game_id, "d", "8", :black)
    Game.put(game_id, "a", "8", :white)
    Game.put(game_id, "b", "7", :black)
    Game.put(game_id, "g", "8", :white)
    Game.put(game_id, "a", "7", :black)
    Game.put(game_id, "g", "6", :white)
    Game.put(game_id, "h", "5", :black)
    Game.put(game_id, "f", "2", :white)
    Game.put(game_id, "h", "6", :black)
    Game.put(game_id, "h", "3", :white)
    Game.put(game_id, "g", "7", :black)
    Game.put(game_id, "h", "4", :white)
    Game.put(game_id, "f", "1", :black)
    Game.put(game_id, "g", "1", :white)
    Game.put(game_id, "g", "3", :black)
    Game.put(game_id, "g", "2", :white)
    Game.put(game_id, "h", "1", :black)
    Game.put(game_id, "h", "2", :white)
    Game.put(game_id, "a", "1", :black)
    Game.put(game_id, "b", "2", :white)
    Game.put(game_id, "a", "2", :black)
    Game.put(game_id, "a", "3", :white)
    Game.put(game_id, "h", "8", :black)
    Game.put(game_id, "h", "7", :white)

    expected = Enum.join [
      "   a b c d e f g h",
      "1 ××××××××",
      "2 ××○○○○○○",
      "3 ○○×○○×○○",
      "4 ○○××××○○",
      "5 ○○××××○○",
      "6 ○×××××○○",
      "7 ××××○○○○",
      "8 ○○○○○○○×" <> "\n"
    ], "\n"

    assert capture_io(fn -> Game.display_board(game_id) end) == expected
  end
end
