defmodule Aoc.Day10 do
  @day "10"

  def part_1(path) do
    path
    |> Aoc.Parser.lines()
    |> Enum.map(fn line ->
      [pattern | rest] = String.split(line, " ")
      {_volts, buttons} = List.pop_at(rest, -1)

      pattern = parse_pattern(pattern)
      buttons = parse_buttons(buttons)

      find_faster_combination(pattern, buttons)
    end)
    |> Enum.sum()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    0
    |> IO.inspect(label: path, limit: :infinity)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt")
    part_1("inputs/day#{@day}_input.txt")

    # IO.inspect("part 2")
    # part_2("inputs/day#{@day}_example.txt")
    # part_2("inputs/day#{@day}_input.txt")
  end

  defp parse_pattern(pattern) do
    pattern
    |> String.replace("[", "")
    |> String.replace("]", "")
    |> String.replace("#", "1")
    |> String.replace(".", "0")
    |> String.reverse()
    |> String.to_integer(2)
  end

  defp parse_buttons(buttons) do
    Enum.map(buttons, fn button ->
      button
      |> String.replace("(", "")
      |> String.replace(")", "")
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(0, fn acc, button ->
        Bitwise.bor(button, Bitwise.bsl(1, acc))
      end)
    end)
  end

  defp find_faster_combination(end_pattern, buttons) do
    1..length(buttons)
    |> Enum.reduce_while(nil, fn i, nil ->
      buttons
      |> Combination.combine(i)
      |> Enum.find(fn combination ->
        new_pattern =
          Enum.reduce(combination, 0, fn button, pattern ->
            # pressing button is a xor operation
            Bitwise.bxor(button, pattern)
          end)

        new_pattern == end_pattern
      end)
      |> case do
        nil ->
          {:cont, nil}

        _ ->
          {:halt, i}
      end
    end)
  end
end
