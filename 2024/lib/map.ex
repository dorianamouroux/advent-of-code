defmodule Aoc.Map do
  defstruct [:height, :width, :data]

  @adjacent_modifiers [
    {-1, 0}, # Up
    {0, -1}, # Left
    {0, 1}, # Right
    {1, 0}, # Down
  ]

  def new(data) when is_map(data) do
    {{max_x, _}, _} = Enum.max_by(data, fn {{x, _y}, _value} -> x end)
    {{_, max_y}, _} = Enum.max_by(data, fn {{_x, y}, _value} -> y end)
    %Aoc.Map{
      height: max_y + 1,
      width: max_x + 1,
      data: data
    }
  end

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
    for y <- 0..(map.height - 1) do
      for x <- 0..(map.width - 1) do
        cell = at(map, x, y)
        IO.write(if(cell != nil, do: cell, else: "."))
      end
      IO.write("\n")
    end
    map
  end

  def put(map, x, y, char) do
    put(map, {x, y}, char)
  end

  def put(map, {x, y}, char) do
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
  end

  def apply_modifier({a, b}, {x, y}) do
    {a + x, b + y}
  end
end
