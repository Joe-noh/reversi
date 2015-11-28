defmodule Reversi.NameResolver do
  use GenServer

  @name __MODULE__

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    {:ok, %{}}
  end

  def register(name, pid) do
    GenServer.cast(@name, {:register, name, pid})
  end

  def whereis(name) do
    GenServer.call(@name, {:whereis, name})
  end

  def handle_cast({:register, name, pid}, map) do
    {:noreply, Map.put(map, name, pid)}
  end

  def handle_call({:whereis, name}, _from, map) do
    {:reply, Map.get(map, name), map}
  end
end
