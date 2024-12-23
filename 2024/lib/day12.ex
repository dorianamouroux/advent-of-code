defmodule Aoc.Day12 do
  @day "12"

  def part_1(path) do
    map = Aoc.Parser.map(path)

    map
    |> get_areas()
    |> Enum.map(fn {letter, positions} ->
      nb_fences = Enum.map(positions, fn pos ->
        map
        |> Aoc.Map.cell_adjacents(pos)
        |> Enum.filter(fn {_pos, value} -> value != letter end)
        |> Enum.count()
      end)
      |> Enum.sum()

      nb_fences * Enum.count(positions)
    end)
    |> Enum.sum()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    map = Aoc.Parser.map(path)

    map
    |> get_areas()
    |> Enum.map(fn {letter, positions} ->
      nb_faces = positions
      |> Enum.map(fn pos -> count_faces(map, letter, pos) end)
      |> Enum.sum()

      nb_faces * Enum.count(positions)
    end)
    |> Enum.sum()
    |> IO.inspect(label: path)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example_1.txt")
    part_1("inputs/day#{@day}_example_2.txt")
    part_1("inputs/day#{@day}_example_3.txt")
    part_1("inputs/day#{@day}_input.txt")

    IO.inspect("part 2")
    part_2("inputs/day#{@day}_example_1.txt")
    part_2("inputs/day#{@day}_example_4.txt")
    part_2("inputs/day#{@day}_input.txt")
  end

  defp get_areas(map) do
    map
    |> Aoc.Map.all_cells()
    |> Enum.reduce({map, []}, fn {pos, _}, {map, all_areas} ->
      area_code = Aoc.Map.at(map, pos)
      if area_code do
        {map, positions} = extract_area(map, pos, area_code)
        {map, [{area_code, positions} | all_areas]}
      else
        {map, all_areas}
      end
    end)
    |> elem(1)
  end

  defp extract_area(map, pos, area, values \\ MapSet.new()) do
    if Aoc.Map.at(map, pos) == area do
      values = MapSet.put(values, pos)
      map = Aoc.Map.put(map, pos, nil)

      map
      |> Aoc.Map.cell_adjacents(pos)
      |> Enum.reject(& Enum.member?(values, &1))
      |> Enum.filter(& elem(&1, 1) == area)
      |> Enum.reduce({map, values}, fn cell_adjacent, {map, values} ->
        {pos_adjecent, _} = cell_adjacent
        extract_area(map, pos_adjecent, area, values)
      end)
    else
      {map, values}
    end
  end

  defp count_faces(map, letter, {x, y}) do
    cell_above = Aoc.Map.at(map, {x, y - 1})
    cell_below = Aoc.Map.at(map, {x, y + 1})
    cell_left = Aoc.Map.at(map, {x - 1, y})
    cell_right = Aoc.Map.at(map, {x + 1, y})
    cell_top_left = Aoc.Map.at(map, {x - 1, y - 1})
    cell_top_right = Aoc.Map.at(map, {x + 1, y - 1})
    cell_bottom_left = Aoc.Map.at(map, {x - 1, y + 1})
    cell_bottom_right = Aoc.Map.at(map, {x + 1, y + 1})

    [
      # out corner
      cell_below != letter && cell_left != letter, # bottom-left
      cell_below != letter && cell_right != letter, # bottom-right
      cell_above != letter && cell_left != letter, # top-left
      cell_above != letter && cell_right != letter, # top-right

      # in corner
      cell_above == letter && cell_right == letter && cell_top_right != letter,
      cell_above == letter && cell_left == letter && cell_top_left != letter,
      cell_below == letter && cell_right == letter && cell_bottom_right != letter,
      cell_below == letter && cell_left == letter && cell_bottom_left != letter,
    ]
    |> Enum.filter(& &1)
    |> Enum.count()
  end
end
