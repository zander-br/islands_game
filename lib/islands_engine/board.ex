defmodule IslandsEngine.Board do
  alias IslandsEngine.Coordinate

  @letters ~W(a b c d e f g h i j)
  @numbers [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

  def start_link(), do: Agent.start_link(&initialized_board/0)

  def get_coordinate(board, key) when is_atom(key),
    do: Agent.get(board, fn board -> board[key] end)

  def guess_coordinate(board, key) do
    coordinate = get_coordinate(board, key)
    Coordinate.guess(coordinate)
  end

  def coordinate_hit?(board, key) do
    coordinate = get_coordinate(board, key)
    Coordinate.hit?(coordinate)
  end

  def set_coordinate_in_island(board, key, island) do
    coordinate = get_coordinate(board, key)
    Coordinate.set_in_island(coordinate, island)
  end

  def coordinate_island(board, key) do
    coordinate = get_coordinate(board, key)
    Coordinate.island(coordinate)
  end

  def to_string(board), do: "%{#{string_body(board)}}"

  defp string_body(board) do
    Enum.reduce(keys(), "", fn key, acc ->
      coordinate = get_coordinate(board, key)
      "#{acc}#{key} => #{Coordinate.to_string(coordinate)},\n"
    end)
  end

  defp initialized_board do
    Enum.reduce(keys(), %{}, fn key, board ->
      {:ok, coordinate} = Coordinate.start_link()
      Map.put_new(board, key, coordinate)
    end)
  end

  defp keys do
    for letter <- @letters, number <- @numbers do
      String.to_atom("#{letter}#{number}")
    end
  end
end
