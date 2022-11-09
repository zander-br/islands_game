defmodule IslandsEngine.Island do
  alias IslandsEngine.Coordinate

  def start_link(), do: Agent.start_link(fn -> [] end)

  def replace_coordinates(island, new_coordinates) when is_list(new_coordinates),
    do: Agent.update(island, fn _state -> new_coordinates end)

  def forested?(island) do
    island
    |> Agent.get(fn state -> state end)
    |> Enum.all?(&Coordinate.hit?/1)
  end

  def to_string(island), do: "[#{coordinate_strings(island)}]"

  defp coordinate_strings(island) do
    island
    |> Agent.get(fn state -> state end)
    |> Enum.map_join(", ", &Coordinate.to_string/1)
  end
end
