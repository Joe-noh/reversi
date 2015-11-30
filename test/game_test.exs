defmodule GameTest do
  use ExUnit.Case

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
end
