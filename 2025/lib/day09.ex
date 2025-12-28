defmodule Aoc.Day09 do
  @day "09"

  def part_1(path) do
    path
    |> Aoc.Parser.points_per_line()
    |> Combination.combine(2)
    |> Enum.map(&get_area/1)
    |> Enum.max()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    points = Aoc.Parser.points_per_line(path)
    edges = Enum.chunk_every(points, 2, 1, [hd(points)])

    {max_x, _} = points |> Enum.max_by(fn {x, _} -> x end)
    {_, max_y} = points |> Enum.max_by(fn {_, y} -> y end)

    map = Aoc.Map.new(max_x + 2, max_y + 2)

    # place perimeter
    map_with_perimeter = place_perimeter(map, edges)
    map_with_line_perimeter = place_line_perimeter(map, map_with_perimeter)

    points_per_y =
      map_with_line_perimeter
      |> Aoc.Map.all_cells()
      |> Enum.group_by(
        fn {{_x, y}, _} -> y end,
        fn {{x, _y}, value} -> {x, value} end
      )

    ranges_per_y =
      points_per_y
      |> Enum.map(fn {y, cells} ->
        ranges_in_y =
          cells
          |> Enum.filter(fn {_, value} -> Enum.member?(["|", "J", "L"], value) end)
          |> Enum.map(fn {x, _value} -> x end)
          |> Enum.sort()
          |> Enum.chunk_every(2)
          |> Enum.map(fn [x1, x2] -> x1..x2 end)

        points_to_ranges =
          points_per_y
          |> Map.get(y)
          |> Enum.map(fn {x, _value} -> x end)
          |> Aoc.Ranges.points_to_ranges()

        {y, Aoc.Ranges.merge_ranges(ranges_in_y ++ points_to_ranges)}
      end)
      |> Map.new()

    path
    |> get_all_points()
    |> Combination.combine(2)
    |> Enum.sort_by(&get_area/1, :desc)
    |> Enum.find(fn [a, b] -> fits_in_area?(a, b, ranges_per_y) end)
    |> then(&get_area/1)
    |> IO.inspect(label: path)
  end

  def fits_in_area?({ax, ay}, {bx, by}, ranges_per_y) do
    {min_y, max_y} = Enum.min_max([ay, by])

    Enum.all?(min_y..max_y, fn y ->
      ranges = Map.get(ranges_per_y, y)

      Enum.any?(ranges, fn range ->
        ax in range and bx in range
      end)
    end)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt")
    part_1("inputs/day#{@day}_input.txt")

    IO.inspect("part 2")
    part_2("inputs/day#{@day}_example.txt")
    # part_2("inputs/day#{@day}_input.txt")
  end

  defp get_all_points(path) do
    path
    |> Aoc.Parser.lines()
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp get_area([{ax, ay}, {bx, by}]) do
    length = abs(ax - bx) + 1
    width = abs(ay - by) + 1
    length * width
  end

  defp place_perimeter(map, edges) do
    Enum.reduce(edges, map, fn [{x1, y1}, {x2, y2}], map ->
      {min_x, max_x} = [x1, x2] |> Enum.min_max()
      {min_y, max_y} = [y1, y2] |> Enum.min_max()

      Enum.reduce(min_x..max_x, map, fn x, map ->
        Enum.reduce(min_y..max_y, map, fn y, map ->
          Aoc.Map.put(map, {x, y}, "#")
        end)
      end)
    end)
  end

  defp place_line_perimeter(map, map_with_perimeter) do
    map_with_perimeter
    |> Aoc.Map.all_cells()
    |> Enum.reduce(map, fn {pos, _sym}, map ->
      new_cell =
        map_with_perimeter
        |> Aoc.Map.cell_adjacents(pos)
        |> Enum.map(fn {_, value} -> value end)
        |> case do
          [nil, "#", "#", nil] ->
            # :horizontal
            "|"

          ["#", nil, nil, "#"] ->
            # :vertical
            "-"

          ["#", "#", nil, nil] ->
            # :bottom_right
            "J"

          ["#", nil, "#", nil] ->
            # :bottom_left
            "7"

          [nil, "#", nil, "#"] ->
            # :bottom_right
            "L"

          [nil, nil, "#", "#"] ->
            # :bottom_left
            "F"
        end

      Aoc.Map.put(map, pos, new_cell)
    end)
  end
end
