defmodule Aoc.Day12 do
  @day "12"

  def part_1(path) do
    {shapes, regions} = parse(path)

    IO.inspect(shapes, label: "shapes")

    regions
    |> Enum.filter(fn {width, height, shape_ids} ->
      size = width * height

      size_of_all_shapes =
        shape_ids
        |> Enum.with_index()
        |> Enum.map(fn {amount, index} ->
          area_shape =
            shapes
            |> Map.get(index)
            |> String.split("")
            |> Enum.count(fn char -> char == "#" end)

          area_shape * amount
        end)
        |> Enum.sum()

      size > size_of_all_shapes
    end)
    |> Enum.count()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    0
    |> IO.inspect(label: path)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt")
    part_1("inputs/day#{@day}_input.txt")

    # IO.inspect("part 2")
    # part_2("inputs/day#{@day}_example.txt")
    # part_2("inputs/day#{@day}_input.txt")
  end

  defp parse(path) do
    file = Aoc.Parser.two_chunks(path)
    {regions, shapes} = List.pop_at(file, -1)

    shapes =
      shapes
      |> Enum.map(fn shape ->
        [index, grid] = String.split(shape, ":\n")

        {String.to_integer(index), grid}
      end)
      |> Map.new()

    regions =
      regions
      |> String.split("\n")
      |> Enum.map(fn region ->
        [size, shape_ids] = String.split(region, ":", trim: true)
        [width, height] = String.split(size, "x", trim: true)

        shape_ids =
          shape_ids
          |> String.split(" ", trim: true)
          |> Enum.map(&String.to_integer/1)

        {String.to_integer(width), String.to_integer(height), shape_ids}
      end)

    {shapes, regions}
  end
end
