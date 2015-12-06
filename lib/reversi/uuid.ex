defmodule Reversi.UUID do
  @max 1000000000

  @spec get :: String.t
  def get do
    :crypto.rand_uniform(0, @max) |> Integer.to_string
  end
end
