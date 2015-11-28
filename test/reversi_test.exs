defmodule ReversiTest do
  use ExUnit.Case
  doctest Reversi

  test "Reversi.NameResolver is up" do
    refute Process.whereis(Reversi.NameResolver) |> is_nil
  end

  test "Reversi.GameSup is up" do
    refute Process.whereis(Reversi.GameSup) |> is_nil
  end
end
