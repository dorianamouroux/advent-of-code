defmodule Day01 do

  def part_1(path) do
    {left_col, right_col} = get_input(path)
    left_col = Enum.sort(left_col)
    right_col = Enum.sort(right_col)

    Enum.sort(left_col)
    |> Enum.zip(right_col)
    |> Enum.map(fn {a, b} ->
      abs(a - b)
    end)
    |> Enum.sum()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    {left_col, right_col} = get_input(path)
    freq_right_col = Enum.frequencies(right_col)

    left_col
    |> Enum.map(fn number ->
      number * Map.get(freq_right_col, number, 0)
    end)
    |> Enum.sum()
    |> IO.inspect(label: path)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day01_example.txt")
    part_1("inputs/day01_input.txt")

    IO.inspect("part 2")
    part_2("inputs/day01_example.txt")
    part_2("inputs/day01_input.txt")
  end

  defp get_input(path) do
    path
    |> File.stream!()
    |> Enum.map(fn line ->
      [left, right] = String.split(line)
      {String.to_integer(left), String.to_integer(right)}
    end)
    |> Enum.unzip() # devide the left from right on each line
  end
end
