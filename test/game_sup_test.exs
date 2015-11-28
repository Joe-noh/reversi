defmodule GameSupTest do
  use ExUnit.Case

  alias Reversi.GameSup

  test "start_game returns uuid" do
    uuid1 = GameSup.start_game
    uuid2 = GameSup.start_game

    assert uuid1 != uuid2
    assert uuid1 |> is_binary
  end
end
