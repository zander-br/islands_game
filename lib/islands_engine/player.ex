defmodule IslandsEngine.Player do
  alias IslandsEngine.{Board, IslandSet, Player}

  defstruct name: :none, board: :none, island_set: :none

  def start_link(name \\ :none) do
    {:ok, board} = Board.start_link()
    {:ok, island_set} = IslandSet.start_link()
    Agent.start_link(fn -> %Player{board: board, island_set: island_set, name: name} end)
  end

  def set_name(player, name),
    do: Agent.update(player, fn state -> Map.put(state, :name, name) end)

  def get_board(player), do: Agent.get(player, fn state -> state.board end)

  def get_island_set(player), do: Agent.get(player, fn state -> state.island_set end)

  def set_island_coordinates(player, island, coordinates) do
    board = get_board(player)
    island_set = get_island_set(player)
    new_coordinates = convert_coordinates(board, coordinates)
    IslandSet.set_island_coordinates(island_set, island, new_coordinates)
  end

  def to_string(player), do: "%Player{#{string_body(player)}}"

  defp convert_coordinates(board, coordinates),
    do: Enum.map(coordinates, fn coordinate -> convert_coordinate(board, coordinate) end)

  defp convert_coordinate(board, coordinate) when is_atom(coordinate),
    do: Board.get_coordinate(board, coordinate)

  defp convert_coordinate(_board, coordinate) when is_pid(coordinate), do: coordinate

  defp string_body(player) do
    state = Agent.get(player, & &1)

    ":name => " <>
      name_to_string(state.name) <>
      ",\n" <>
      ":island_set => " <>
      IslandSet.to_string(state.island_set) <>
      ",\n" <>
      ":board => " <> Board.to_string(state.board)
  end

  defp name_to_string(:none), do: ":none"
  defp name_to_string(name), do: ~s("#{name}")
end
