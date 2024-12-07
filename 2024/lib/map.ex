defmodule Aoc.Map do
  defstruct [:height, :width, :data]

  def new(lines) do
    %Aoc.Map{
      height: length(lines),
      width: length(hd(lines)),
      data: to_hashmap(lines)
    }
  end

  defp to_hashmap(lines) do
    map = for {line, y} <- Enum.with_index(lines) do
      for {char, x} <- Enum.with_index(line) do
        {{x, y}, char}
      end
    end

    map
    |> List.flatten()
    |> Map.new()
  end

  def at(map, x, y) do
    Map.get(map.data, {x, y})
  end

  def put(map, x, y, char) do
    data = Map.put(map.data, {x, y}, char)
    Map.put(map, :data, data)
  end

  def all_cells(map) do
    map.data
  end

  def find(map, char_to_find) do
    map
    |> all_cells()
    |> Enum.find_value(fn {pos, char} ->
      if char == char_to_find do
        pos
      end
    end)
  end

  def get_directions() do
    [
      {-1, -1}, # Up-Left
      {-1, 0}, # Up
      {-1, 1}, # Up-Right
      {0, -1}, # Left
      {0, 1}, # Right
      {1, -1}, # Down-Left
      {1, 0}, # Down
      {1, 1}, # Down-Right
    ]
  end
end
