defmodule Aoc.Day03 do
  @day "03"

  def part_1(path) do
    path
    |> Aoc.Parser.numbers_on_lines()
    |> Enum.map(&find_biggest_number(&1, 2))
    |> Enum.sum()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    path
    |> Aoc.Parser.numbers_on_lines()
    |> Enum.map(&find_biggest_number(&1, 12))
    |> Enum.sum()
    |> IO.inspect(label: path)
  end

  defp find_biggest_number(bank, length_number) do
    1..length_number
    |> Enum.reduce({bank, 0}, fn value, {bank, acc} ->
      findable_numbers = Enum.take(bank, length(bank) - length_number + value)
      number = Enum.max(findable_numbers)
      number_index = Enum.find_index(bank, &(&1 == number))
      rest_battery_bank = Enum.drop(bank, number_index + 1)
      new_number = acc * 10 + number

      {rest_battery_bank, new_number}
    end)
    |> elem(1)
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
