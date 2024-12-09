defmodule Aoc.Day08 do
  @day "08"

  def part_1(path) do
    path
    |> apply_antinodes(1)
    |> Aoc.Map.all_cells()
    |> Enum.count(fn {_pos, cell} -> cell == "#" end)
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    path
    |> apply_antinodes(50)
    |> Aoc.Map.all_cells()
    |> Enum.count(fn {_pos, cell} -> cell != "." end)
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

  defp apply_antinodes(path, limit) do
    map = Aoc.Parser.map(path)

    map
    |> Aoc.Map.all_cells()
    |> Enum.reject(fn {_pos, cell} -> cell == "." end) # get all antennas
    |> Enum.group_by(fn {_pos, cell} -> cell end, fn {pos, _cell} -> pos end) # one group of pos per antennas
    |> Enum.map(fn {_char, antennas} -> get_antinodes(map, antennas, limit) end)
    |> List.flatten()
    |> Enum.reduce(map, fn {x, y}, map ->
      # apply antinodes on the map
      Aoc.Map.put(map, x, y, "#")
    end)
  end

  defp get_antinodes(map, antennas, limit) do
    pairs = for x <- antennas, y <- antennas, x != y, do: {x, y}

    pairs
    |> Enum.map(fn {pos_1, pos_2} ->
      Enum.reduce_while(1..limit, [], fn factor, antinodes ->
        {x, y} = get_antinode(pos_1, pos_2, factor)
        if Aoc.Map.at(map, x, y) do
          {:cont, [{x, y} | antinodes]}
        else
          {:halt, antinodes} # reached the bound of the map
        end
      end)
    end)
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
  end

  defp get_antinode({a, b}, {x, y}, factor) do
    {diff_x, diff_y} = {x - a, y - b}
    {x + (factor * diff_x), y + (factor * diff_y)}
  end
end
