defmodule Aoc.Day05 do
  @day "05"

  def part_1(path) do
    [all_ranges, numbers] = Aoc.Parser.two_chunks(path)

    ranges = get_ranges(all_ranges)

    numbers
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.count(fn number ->
      Enum.any?(ranges, fn range -> number in range end)
    end)
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    [all_ranges, _] = Aoc.Parser.two_chunks(path)
    ranges = get_ranges(all_ranges)

    ranges
    |> Enum.sort()
    |> merge_ranges([])
    |> IO.inspect(label: "merged")
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
    |> IO.inspect(label: path)
  end

  defp merge_ranges([], merged), do: merged

  defp merge_ranges([current_range | rest_ranges], []),
    do: merge_ranges(rest_ranges, [current_range])

  defp merge_ranges([current_range | rest_ranges], merged) do
    last_range = hd(merged)

    if Range.disjoint?(current_range, last_range) do
      merge_ranges(rest_ranges, [current_range | merged])
    else
      [last_range | rest_merged] = merged
      start_range = last_range.first
      end_range = Enum.max([current_range.last, last_range.last])
      new_range = start_range..end_range
      merge_ranges(rest_ranges, [new_range | rest_merged])
    end
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt")
    part_1("inputs/day#{@day}_input.txt")

    IO.inspect("part 2")
    part_2("inputs/day#{@day}_example.txt")
    part_2("inputs/day#{@day}_input.txt")
  end

  defp get_ranges(all_ranges) do
    all_ranges
    |> String.split("\n", trim: true)
    |> Enum.map(fn range ->
      [left, right] =
        range
        |> String.split("-")
        |> Enum.map(&String.to_integer/1)

      left..right
    end)
  end
end
