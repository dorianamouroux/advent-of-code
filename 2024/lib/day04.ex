defmodule Aoc.Day04 do
  @day "04"

  def part_1(path) do
    input = Aoc.Parser.map(path)
    all_directions = Aoc.Map.get_directions()

    input
    |> Aoc.Map.all_cells()
    |> Enum.map(fn {pos, _} ->
      Enum.count(all_directions, fn direction ->
        is_written_word(input, ["X", "M", "A", "S"], pos, direction)
      end)
    end)
    |> Enum.sum()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    input = Aoc.Parser.map(path)

    input
    |> Aoc.Map.all_cells()
    |> Enum.count(fn {pos, _} -> is_xmas_cross(input, pos) end)
    |> IO.inspect(label: path)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt")
    part_1("inputs/day#{@day}_input.txt")

    IO.inspect("part 2")
    part_2("inputs/day#{@day}_example_2.txt")
    part_2("inputs/day#{@day}_input.txt")
  end

  def is_xmas_cross(input, {x, y}) do
    first_diag = [
      Aoc.Map.at(input, x - 1, y - 1), # top left
      Aoc.Map.at(input, x, y),
      Aoc.Map.at(input, x + 1, y + 1) # bottom right
    ]

    second_diag = [
      Aoc.Map.at(input, x - 1, y + 1), # bottom left
      Aoc.Map.at(input, x, y),
      Aoc.Map.at(input, x + 1, y - 1) # top right
    ]

    a = first_diag == ["M", "A", "S"] || first_diag == ["S", "A", "M"]
    b = second_diag == ["M", "A", "S"] || second_diag == ["S", "A", "M"]

    a && b
  end

  def is_written_word(_, [], _, _), do: true
  def is_written_word(input, [letter | rest], {x, y}, {direction_x, direction_y}) do
    if Aoc.Map.at(input, x, y) == letter do
      is_written_word(input, rest, {x + direction_x, y + direction_y}, {direction_x, direction_y})
    else
      false
    end
  end
end
