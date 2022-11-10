defmodule IslandsEngine.Coordinate do
  alias IslandsEngine.Coordinate

  defstruct guessed?: false, in_island: :none

  def start_link(), do: Agent.start_link(fn -> %Coordinate{} end)

  def guessed?(coordinate),
    do: Agent.get(coordinate, fn state -> state.guessed? end)

  def island(coordinate),
    do: Agent.get(coordinate, fn state -> state.in_island end)

  def in_island?(coordinate) do
    case island(coordinate) do
      :none -> false
      _ -> true
    end
  end

  def hit?(coordinate), do: in_island?(coordinate) && guessed?(coordinate)

  def guess(coordinate),
    do: Agent.update(coordinate, fn state -> Map.put(state, :guessed?, true) end)

  def set_in_island(coordinate, value) when is_atom(value),
    do: Agent.update(coordinate, fn state -> Map.put(state, :in_island, value) end)

  def to_string(coordinate),
    do: "(in_island: #{island(coordinate)}, guessed: #{guessed?(coordinate)})"
end
