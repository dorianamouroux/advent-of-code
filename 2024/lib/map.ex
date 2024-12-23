defmodule Aoc.Map do
  defstruct [:height, :width, :data]

  @adjacent_modifiers [
    {-1, 0}, # Up
    {0, -1}, # Left
    {0, 1}, # Right
    {1, 0}, # Down
  ]

  def new(lines) do
    %Aoc.Map{
      height: length(lines),
      width: length(hd(lines)),
      data: to_hashmap(lines)
    }
  end

  def update_all_cells(map, func) do
    data = map.data
    |> Enum.map(fn {pos, value} -> {pos, func.(value)} end)
    |> Map.new()

    %{map | data: data}
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
    at(map, {x, y})
  end

  def at(map, {x, y}) do
    Map.get(map.data, {x, y})
  end

  def print(map) do
    for y <- 0..map.height do
      for x <- 0..map.width do
        IO.write(at(map, x, y))
      end
      IO.write("\n")
    end
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

  def cell_adjacents(map, {x, y}) do
    @adjacent_modifiers
    |> Enum.map(fn {a, b} ->
      pos = {x + a, y + b}
      {pos, at(map, pos)}
    end)
    |> Enum.reject(& elem(&1, 1) == nil)
  end
end
