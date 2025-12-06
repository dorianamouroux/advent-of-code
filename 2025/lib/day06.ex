defmodule Aoc.Day06 do
  @day "06"

  def part_1(path) do
    path
    |> Aoc.Parser.lines()
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.zip()
    |> Enum.map(fn operation ->
      size_operation = tuple_size(operation)
      sign = elem(operation, size_operation - 1)

      operation =
        operation
        |> Tuple.to_list()
        |> Enum.drop(-1)
        |> Enum.map(&String.to_integer/1)

      case sign do
        "+" -> Enum.sum(operation)
        "*" -> Enum.product(operation)
      end
    end)
    |> Enum.sum()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    path
    |> Aoc.Parser.lines()
    |> Enum.map(&String.split(&1, ""))
    |> Enum.zip()
    |> Enum.map(fn operation -> operation |> Tuple.to_list() |> Enum.join("") end)
    |> List.flatten()
    |> Enum.reduce({[], []}, fn operation, {all_operations, current_element} ->
      if String.trim(operation) == "" do
        {all_operations ++ [current_element], []}
      else
        {all_operations, current_element ++ [operation]}
      end
    end)
    |> elem(0)
    |> Enum.reject(&Enum.empty?/1)
    |> Enum.map(fn operation ->
      sign = String.last(hd(operation))

      numbers =
        operation
        |> Enum.map(fn number ->
          number
          |> String.replace([" ", "+", "*"], "")
          |> String.to_integer()
        end)

      case sign do
        "+" -> Enum.sum(numbers)
        "*" -> Enum.product(numbers)
      end
    end)
    |> Enum.sum()
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
