defmodule Aoc.Day10 do
  @day "10"

  def part_1(path) do
    path
    |> count_paths(true)
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    path
    |> count_paths(false)
    |> IO.inspect(label: path)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example_1.txt")
    part_1("inputs/day#{@day}_example_2.txt")
    part_1("inputs/day#{@day}_input.txt")

    IO.inspect("part 2")
    part_2("inputs/day#{@day}_example_2.txt")
    part_2("inputs/day#{@day}_input.txt")
  end

  defp count_paths(path, distinct_end) do
    map = path
    |> Aoc.Parser.map()
    |> Aoc.Map.update_all_cells(&String.to_integer/1)

    starting_cells = map
    |> Aoc.Map.all_cells()
    |> Enum.filter(fn {_pos, value} -> value == 0 end)

    starting_cells
    |> Enum.map(fn cell ->
      map
      |> get_all_paths([cell])
      |> List.flatten()
      |> then(& if(distinct_end, do: MapSet.new(&1), else: &1))
      |> Enum.count
    end)
    |> Enum.sum()
  end

  defp get_all_paths(_map, [{_, 9} | _rest] = visited) do
    {head, _} = hd(visited)
    {tail, _} = List.last(visited)
    {head, tail}
  end

  defp get_all_paths(map, visited) do
    {current, value} = hd(visited)

    map
    |> Aoc.Map.cell_adjacents(current)
    |> Enum.filter(fn {_, value_adjacent} ->
      value + 1 == value_adjacent
    end)
    |> Enum.map(fn cell_adjacent ->
      get_all_paths(map, [cell_adjacent | visited])
    end)
  end
end
