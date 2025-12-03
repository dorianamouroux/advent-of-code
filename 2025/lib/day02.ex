defmodule Aoc.Day02 do
  @day "02"

  def part_1(path) do
    path
    |> analyze_ranges(fn number ->
      nb_digits = number |> Integer.digits() |> length()

      if rem(nb_digits, 2) == 0 do
        half_point = floor(:math.pow(10, nb_digits / 2))
        left = floor(number / half_point)
        right = rem(number, half_point)
        left == right
      end
    end)
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    path
    |> analyze_ranges(fn number ->
      number
      |> get_subgroups()
      |> Enum.any?(fn group ->
        first_elem = hd(group)
        Enum.all?(group, fn elem -> elem == first_elem end)
      end)
    end)
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

  defp analyze_ranges(path, fun_is_incorrect) do
    path
    |> Aoc.Parser.read_file()
    |> String.split(",")
    |> Enum.map(fn range ->
      [min, max] =
        range
        |> String.split("-")
        |> Enum.map(&String.to_integer/1)

      min..max
      |> Enum.filter(fn number -> number > 10 and fun_is_incorrect.(number) end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  defp get_subgroups(number) do
    digits = Integer.digits(number)

    groups =
      case length(digits) do
        4 -> [2]
        6 -> [2, 3]
        8 -> [2, 4]
        9 -> [3]
        10 -> [2, 5]
        _ -> []
      end

    groups = groups ++ [1]

    Enum.map(groups, fn nb_digit ->
      Enum.chunk_every(digits, nb_digit)
    end)
  end
end
