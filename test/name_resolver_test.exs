defmodule NameResolverTest do
  use ExUnit.Case

  alias Reversi.NameResolver, as: Resolver

  test "register and whereis" do
    Resolver.register("this_is_me", self)
    pid = Resolver.whereis("this_is_me")

    assert pid == self
  end

  test "register many pids" do
    Resolver.register("one",   spawn fn -> nil end)
    Resolver.register("two",   spawn fn -> nil end)
    Resolver.register("three", spawn fn -> nil end)

    pids = [
      Resolver.whereis("one"),
      Resolver.whereis("two"),
      Resolver.whereis("three")
    ]

    assert Enum.uniq(pids) == pids
  end
end
