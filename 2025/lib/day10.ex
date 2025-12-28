defmodule Aoc.Day10 do
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
    # |> Enum.slice(1, 2)
    |> Enum.map(fn line ->
      {_pattern, buttons, volts} = parse_line(line)
      # {nb_presses, _} = find_faster_combination(pattern, buttons)
      # nb_presses
      solve_voltage(buttons, volts)
    end)
    |> IO.inspect(label: "results", charlists: :as_lists)
    |> Enum.sum()
    |> IO.inspect(label: path, charlists: :as_lists)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt")
    part_1("inputs/day#{@day}_input.txt")

    IO.inspect("part 2")
    part_2("inputs/day#{@day}_example.txt")
    # part_2("inputs/day#{@day}_input.txt")
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

  defp find_all_combination(end_pattern, buttons) do
    Enum.reduce(1..length(buttons), [], fn i, results ->
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

  defp solve_voltage(buttons, volts) do
    pattern =
      volts
      |> IO.inspect(label: "volts")
      |> Enum.map(fn number ->
        if rem(number, 2) == 1 do
          "1"
        else
          "0"
        end
      end)
      |> Enum.join("")
      |> String.reverse()
      |> IO.inspect(label: "odd/even")
      |> String.to_integer(2)

    cond do
      Enum.all?(volts, &(&1 == 0)) ->
        0

      Enum.any?(volts, &(&1 < 0)) ->
        99_999_999

      true ->
        pattern
        |> find_all_combination(buttons)
        |> Enum.map(fn result ->
          print_buttons(result)
          new_volts = press_buttons_for_volts(volts, result)
          IO.inspect(new_volts, label: "new_volts", charlists: :as_lists)

          new_volts = Enum.map(new_volts, &ceil(&1 / 2))
          solve_voltage(buttons, new_volts) * 2 + length(result)
        end)
        |> Enum.min()
    end
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

  defp print_buttons(buttons) do
    buttons
    |> Enum.each(fn button ->
      IO.write("(")

      button
      |> Integer.digits(2)
      |> Enum.reverse()
      |> Enum.with_index(fn bit, index ->
        if bit == 1 do
          IO.write(index)
          IO.write(",")
        end
      end)

      IO.write(") ")
    end)

    IO.write("\n")
  end

  defp print_pattern(pattern) do
    pattern
    |> Integer.digits(2)
    |> IO.inspect(label: "pattern")
  end
end
