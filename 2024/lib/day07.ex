defmodule Aoc.Day07 do
  @day "07"

  def part_1(path) do
    compute_with_ops(path, [&add/2, &multiply/2])
  end

  def part_2(path) do
    compute_with_ops(path, [&add/2, &multiply/2, &concat_numbers/2])
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt")
    part_1("inputs/day#{@day}_input.txt")

    IO.inspect("part 2")
    part_2("inputs/day#{@day}_example.txt")
    part_2("inputs/day#{@day}_input.txt")
  end

  defp compute_with_ops(path, ops) do
    path
    |> Aoc.Parser.lines()
    |> Enum.map(&parse_line/1)
    |> Enum.filter(fn {result, numbers} ->
      is_good_equation(result, numbers, ops)
    end)
    |> Enum.map(fn {result, _} -> result end)
    |> Enum.sum
    |> IO.inspect(label: path)
  end

  defp is_good_equation(result, [], current, _ops) do
    result == current
  end

  defp is_good_equation(result, [first_number | rest_numbers], current, ops) do
    Enum.any?(ops, fn op ->
      is_good_equation(result, rest_numbers, op.(current, first_number), ops)
    end)
  end

  defp is_good_equation(result, [first_number | rest_numbers], ops) do
    is_good_equation(result, rest_numbers, first_number, ops)
  end

  defp parse_line(line) do
    [result, numbers] = String.split(line, ": ")
    result = String.to_integer(result)
    numbers = numbers |> String.split(" ") |> Enum.map(&String.to_integer/1)

    {result, numbers}
  end

  defp add(a, b), do: a + b
  defp multiply(a, b), do: a * b
  defp concat_numbers(a, b), do: String.to_integer(to_string(a) <> to_string(b))
end
