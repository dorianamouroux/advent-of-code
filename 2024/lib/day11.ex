defmodule Aoc.Day11 do
  @day "11"

  require Integer

  def part_1(path) do
    path
    |> blink_x_times(25)
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    path
    |> blink_x_times(75)
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

  defp blink_x_times(path, amount) do
    stones = path
    |> Aoc.Parser.numbers_on_lines()
    |> hd()
    |> Enum.map(& {&1, 1})
    |> Map.new()

    Enum.reduce(0..(amount - 1), stones, fn _, stones ->
      blink_stones(stones)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  defp blink_stones(stones) do
    Enum.reduce(stones, %{}, fn {stone, amount}, all_stones ->
      stone
      |> split_stone(amount)
      |> put_stones(all_stones)
    end)
  end

  defp split_stone(stone, amount) do
    digits = Integer.digits(stone)
    nb_digits = length(digits)

    cond do
      stone == 0 ->
        [{1, amount}]
      Integer.is_even(nb_digits)->
        digits
        |> Enum.split(round(nb_digits / 2))
        |> Tuple.to_list()
        |> Enum.map(fn number ->
          number = number
          |> Enum.join("")
          |> String.to_integer()

          {number, amount}
        end)
      true ->
        [{stone * 2024, amount}]
    end
  end

  defp put_stones(stones, all_stones) do
    Enum.reduce(stones, all_stones, fn stone, all_stones ->
      {stone, amount} = stone
      Map.update(all_stones, stone, amount, & &1 + amount)
    end)
  end
end
