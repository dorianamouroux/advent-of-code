defmodule Aoc.DayExample do
  @day "01"

  def part_1(path) do
    0
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    0
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
end
