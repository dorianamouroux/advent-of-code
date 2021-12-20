defmodule Day12.Part2 do
  def main() do
    Day12.Part2.Parsing.parse()
    |> find_end(["start"])
    |> IO.inspect()
  end

  def find_end(_, ["end" | _]), do: 1

  def find_end(paths, [to_visit | _] = visited) do
    paths
    |> Map.get(to_visit)
    |> Enum.reject(&should_skip(&1, visited))
    |> Enum.reduce(0, fn next, total ->
      total + find_end(paths, [next | visited])
    end)
  end

  # never go back to start
  def should_skip("start", _), do: true

  def should_skip(next, visited) do
    is_small_cave(next) and was_any_small_cave_visited_more_than_once(visited)
  end

  def was_any_small_cave_visited_more_than_once(visited) do
    nb_small_cave_visited_more_than_once =
      visited
      |> Enum.filter(&(&1 != "start" and is_small_cave(&1)))
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.filter(&(&1 > 1))
      |> Enum.sum()

    nb_small_cave_visited_more_than_once > 2
  end

  def is_small_cave(cave), do: cave != String.upcase(cave)
end

defmodule Day12.Part2.Parsing do
  def parse() do
    [filename] = System.argv()

    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> paths_as_map()
  end

  defp paths_as_map(paths) do
    paths
    |> Enum.map(&String.split(&1, "-"))
    |> then(fn paths ->
      reversed = Enum.map(paths, &Enum.reverse/1)
      paths ++ reversed
    end)
    |> Enum.group_by(&Enum.at(&1, 0), &Enum.at(&1, 1))
  end
end
