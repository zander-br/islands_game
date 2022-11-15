defmodule IslandsEngine.Game do
  use GenServer

  alias IslandsEngine.{Game, Player}

  defstruct player1: :none, player2: :none

  def start_link(name) when not is_nil(name), do: GenServer.start_link(__MODULE__, name)

  def init(name) do
    {:ok, player1} = Player.start_link(name)
    {:ok, player2} = Player.start_link()
    {:ok, %Game{player1: player1, player2: player2}}
  end

  def add_player(pid, name) when name != nil, do: GenServer.call(pid, {:add_player, name})

  def set_island_coordinates(pid, player, island, coordinates)
      when is_atom(player) and is_atom(island),
      do: GenServer.call(pid, {:set_island_coordinates, player, island, coordinates})

  def handle_call({:add_player, name}, _from, state) do
    Player.set_name(state.player2, name)
    {:reply, :ok, state}
  end

  def handle_call({:set_island_coordinates, player, island, coordinates}, _from, state) do
    state
    |> Map.get(player)
    |> Player.set_island_coordinates(island, coordinates)

    {:reply, :ok, state}
  end

  def handle_call(:demo, _from, state), do: {:reply, state, state}

  def handle_info(:first, state) do
    IO.puts("This message has been handled by handle_info/2, matching on :first.")
    {:noreply, state}
  end

  def handle_info(_, state), do: {:noreply, state}

  def call_demo(game), do: GenServer.call(game, :demo)

  def handle_cast(:demo, state), do: {:noreply, %{state | test: "new value"}}
end
