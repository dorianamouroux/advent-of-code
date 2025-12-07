defmodule Aoc.Day07 do
  @day "07"

  def part_1(path) do
    map = Aoc.Parser.map(path)
    {start_pos, _} = Aoc.Map.find_cell(map, "S")

    explore(map, start_pos, %{})
    |> elem(1)
    |> Map.get("nb_splits")
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    map = Aoc.Parser.map(path)
    {start_pos, _} = Aoc.Map.find_cell(map, "S")

    explore(map, start_pos, %{})
    |> elem(0)
    |> IO.inspect(label: path)
  end

  defp explore(map, {x, y}, cache) do
    next_pos = {x, y + 1}

    if Map.has_key?(cache, next_pos) do
      {Map.get(cache, next_pos), cache}
    else
      {value, cache} =
        case Aoc.Map.at(map, next_pos) do
          nil ->
            {1, cache}

          "." ->
            explore(map, next_pos, cache)

          "^" ->
            # hack the cache by recording for p1 the number of splits
            cache = Map.put(cache, "nb_splits", Map.get(cache, "nb_splits", 0) + 1)
            {value_left, cache} = explore(map, {x - 1, y + 1}, cache)
            {value_right, cache} = explore(map, {x + 1, y + 1}, cache)
            {value_left + value_right, cache}
        end

      {value, Map.put(cache, next_pos, value)}
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
end
