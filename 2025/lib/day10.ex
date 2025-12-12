defmodule Aoc.Day10 do
  @day "10"

  def part_1(path) do
    path
    |> Aoc.Parser.lines()
    |> Enum.map(fn line ->
      [pattern | rest] = String.split(line, " ")
      {_volts, buttons} = List.pop_at(rest, -1)

      {parse_pattern(pattern), parse_buttons(buttons)}
    end)
    |> Enum.map(fn {pattern, buttons}  ->
      pattern
      |> find_faster_combination(buttons)
      |> Enum.map(fn solutions ->
        solutions
        |> Tuple.to_list()
        |> length()
      end)
      |> Enum.min()
      |> IO.inspect(label: pattern)
    end)
    |> Enum.sum()
    |> IO.inspect(label: path)

    # "...."
    # |> press_button([1, 3])
    # |> IO.inspect

    # find_faster_combination(pattern, buttons)
    # |> IO.inspect(limit: :infinity)
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

  defp press_button(pattern, button) do
    Enum.reduce(button, pattern, fn i, pattern ->
      new_char = case String.at(pattern, i) do
        "#" -> "."
        "." -> "#"
      end

      left  = String.slice(pattern, 0, i)
      right = String.slice(pattern, i + 1, String.length(pattern) - i - 1)
      left <> new_char <> right
    end)
  end

  defp parse_pattern(pattern) do
    pattern
    |> String.replace("[", "")
    |> String.replace("]", "")
  end

  defp parse_buttons(buttons) do
    Enum.map(buttons, fn button ->
      button
      |> String.replace("(", "")
      |> String.replace(")", "")
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp find_faster_combination(end_pattern, buttons, current_pattern \\ nil, pressed \\ [])
  defp find_faster_combination(end_pattern, buttons, nil, pressed) do
    current_pattern = "."
    |> List.duplicate(String.length(end_pattern))
    |> to_string()

    find_faster_combination(end_pattern, buttons, current_pattern, pressed)
  end

  defp find_faster_combination(pattern, buttons, current_pattern, pressed) do
    buttons
    |> Enum.reject(& &1 in pressed)
    |> Enum.reduce([], fn button, solutions ->
      current_pattern = press_button(current_pattern, button)
      if current_pattern == pattern do
        solutions ++ [List.to_tuple([button | pressed])]
      else
        solutions ++ find_faster_combination(pattern, buttons, current_pattern, [button | pressed])
      end
    end)
    |> Enum.filter(fn a -> a end)
    |> List.flatten()
  end
end
