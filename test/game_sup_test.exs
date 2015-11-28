defmodule GameSupTest do
  use ExUnit.Case

  alias Reversi.GameSup
  alias Reversi.NameResolver

  test "start_game returns uuid" do
    uuid1 = GameSup.start_game
    uuid2 = GameSup.start_game

    assert uuid1 != uuid2
    assert uuid1 |> is_binary
  end

  test "start_game registers uuid on NameResolver" do
    uuid = GameSup.start_game

    refute NameResolver.whereis(uuid) |> is_nil
  end
end
