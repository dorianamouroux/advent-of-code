defmodule Aoc.Day10 do
  use Memoize

  @day "10"

  def part_1(path) do
    path
    |> Aoc.Parser.lines()
    |> Enum.map(fn line ->
      {pattern, buttons, _volts} = parse_line(line)

      pattern
      |> find_all_combination(buttons)
      |> Enum.min_by(&length/1)
      |> length()
    end)
    |> Enum.sum()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    path
    |> Aoc.Parser.lines()
    |> Task.async_stream(
      fn line ->
        {_pattern, buttons, volts} = parse_line(line)
        solve_voltage(buttons, volts)
      end,
      timeout: :infinity
    )
    |> Enum.sum_by(fn {:ok, result} -> result end)
    |> IO.inspect(label: path, charlists: :as_lists)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt")
    part_1("inputs/day#{@day}_input.txt")

    IO.inspect("part 2")
    part_2("inputs/day#{@day}_example.txt")
    part_2("inputs/day#{@day}_input.txt")
  end

  defp parse_line(line) do
    [pattern | rest] = String.split(line, " ")
    {volts, buttons} = List.pop_at(rest, -1)

    pattern =
      pattern
      |> String.replace("[", "")
      |> String.replace("]", "")
      |> String.replace("#", "1")
      |> String.replace(".", "0")
      |> String.reverse()
      |> String.to_integer(2)

    buttons =
      Enum.map(buttons, fn button ->
        button
        |> Aoc.Parser.numbers_on_string()
        |> Enum.reduce(0, fn acc, button ->
          Bitwise.bor(button, Bitwise.bsl(1, acc))
        end)
      end)

    volts = Aoc.Parser.numbers_on_string(volts)

    {pattern, buttons, volts}
  end

  defmemo find_all_combination(end_pattern, buttons) do
    Enum.reduce(0..length(buttons), [], fn i, results ->
      buttons
      |> Combination.combine(i)
      |> Enum.filter(fn combination_of_buttons ->
        new_pattern = press_buttons(0, combination_of_buttons)
        new_pattern == end_pattern
      end)
      |> Kernel.++(results)
    end)
  end

  defp press_buttons(pattern, buttons) do
    Enum.reduce(buttons, pattern, fn button, pattern ->
      # pressing button is a xor operation
      Bitwise.bxor(button, pattern)
    end)
  end

  defmemo solve_voltage(buttons, volts) do
    cond do
      Enum.all?(volts, &(&1 == 0)) ->
        0

      Enum.any?(volts, &(&1 < 0)) ->
        99_999_999

      true ->
        volts
        |> volts_to_pattern()
        |> find_all_combination(buttons)
        |> Enum.map(fn result ->
          new_volts =
            volts
            |> press_buttons_for_volts(result)
            |> Enum.map(&ceil(&1 / 2))

          solve_voltage(buttons, new_volts) * 2 + length(result)
        end)
        |> Enum.min(&<=/2, fn -> 99_999_999 end)
    end
  end

  defp volts_to_pattern(volts) do
    volts
    |> Enum.map(&Integer.to_string(Integer.mod(&1, 2)))
    |> Enum.join("")
    |> String.reverse()
    |> String.to_integer(2)
  end

  defp press_buttons_for_volts(volts, buttons) do
    buttons =
      Enum.map(buttons, fn button ->
        button
        |> Integer.digits(2)
        |> Enum.reverse()
      end)

    volts
    |> Enum.with_index()
    |> Enum.map(fn {volt, index} ->
      to_deduce = Enum.count(buttons, fn button -> Enum.at(button, index) == 1 end)
      volt - to_deduce
    end)
  end
end
