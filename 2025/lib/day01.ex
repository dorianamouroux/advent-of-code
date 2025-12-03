defmodule Aoc.Day01 do
  def part_1(path) do
    rotate_lock(path, fn
      value when rem(value, 100) == 0 -> 1
      _ -> 0
    end)
  end

  def part_2(path) do
    rotate_lock(path, fn
      value when value < 0 ->
        abs(value / 100) |> ceil()

      value when value > 99 ->
        abs(value / 100) |> floor()

      _ ->
        0
    end)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day01_example.txt")
    part_1("inputs/day01_input.txt")

    IO.inspect("part 2")
    part_2("inputs/day01_example.txt")
    part_2("inputs/day01_input.txt")
  end

  defp rotate_lock(path, fun_count) do
    path
    |> Aoc.Parser.lines()
    |> Enum.reduce({50, 0}, fn line, {current_value, password} ->
      {direction, value} = String.split_at(line, 1)
      value = String.to_integer(value)

      next_value =
        case direction do
          "L" -> current_value - value
          "R" -> current_value + value
        end

      password = password + fun_count.(next_value)
      next_value = rem(next_value + 100_000, 100)
      {next_value, password}
    end)
    |> elem(1)
    |> IO.inspect(label: path)
  end
end
