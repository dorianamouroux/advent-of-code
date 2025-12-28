defmodule Aoc.Ranges do
  def points_to_ranges(points) do
    points
    |> Enum.sort()
    |> Enum.reduce([], fn number, ranges ->
      if Enum.empty?(ranges) do
        [number..number]
      else
        last_range = hd(ranges)
        last_range_start = last_range.first
        last_range_end = last_range.last

        if number == last_range_end + 1 do
          rest_ranges = tl(ranges)
          [last_range_start..number | rest_ranges]
        else
          [number..number | ranges]
        end
      end
    end)
  end

  def merge_ranges(ranges) do
    ranges
    |> Enum.sort()
    |> do_merge_ranges([])
  end

  def do_merge_ranges([], merged), do: merged

  def do_merge_ranges([current_range | rest_ranges], []),
    do: do_merge_ranges(rest_ranges, [current_range])

  def do_merge_ranges([current_range | rest_ranges], merged) do
    last_range = hd(merged)

    if Range.disjoint?(current_range, last_range) do
      do_merge_ranges(rest_ranges, [current_range | merged])
    else
      [last_range | rest_merged] = merged
      start_range = last_range.first
      end_range = Enum.max([current_range.last, last_range.last])
      new_range = start_range..end_range
      do_merge_ranges(rest_ranges, [new_range | rest_merged])
    end
  end
end
