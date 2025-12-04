defmodule Aoc.Day04 do
  @day "04"

  def part_1(path) do
    map = Aoc.Parser.map(path)

    map
    |> rolls_that_can_be_removed()
    |> Enum.count()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    map = Aoc.Parser.map(path)

    1..999_999_999_999
    |> Enum.reduce_while({map, 0}, fn _, {map, nb_rolls_removed} ->
      removable_rolls = rolls_that_can_be_removed(map)

      if Enum.empty?(removable_rolls) do
        {:halt, nb_rolls_removed}
      else
        map = remove_all_rolls(map, removable_rolls)
        {:cont, {map, nb_rolls_removed + length(removable_rolls)}}
      end
    end)
    |> IO.inspect(label: path)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt")
    part_1("inputs/day#{@day}_input.txt")

    IO.inspect("part 2")
    part_2("inputs/day#{@day}_example.txt")
    part_2("inputs/day#{@day}_input.txt")
  end

  defp rolls_that_can_be_removed(map) do
    map
    |> Aoc.Map.all_cells()
    |> Enum.filter(fn {pos, value} ->
      if value == "@" do
        nb_rolls_around =
          Aoc.Map.cell_adjacents_with_corners(map, pos)
          |> Enum.count(fn {_, value} -> value == "@" end)

        nb_rolls_around < 4
      end
    end)
  end

  defp remove_all_rolls(map, rolls) do
    Enum.reduce(rolls, map, fn {pos, _}, map ->
      Aoc.Map.put(map, pos, ".")
    end)
  end
end
