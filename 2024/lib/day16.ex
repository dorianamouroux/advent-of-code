defmodule Aoc.Day16 do
  @day "16"

  def part_1(path) do
    map = Aoc.Parser.map(path)
    {start_pos, _} = Aoc.Map.find_cell(map, "S")
    {end_pos, _} = Aoc.Map.find_cell(map, "E")

    data = dijkstra(map, start_pos, end_pos)

    data
    |> IO.inspect(label: path)
  end

  # def part_2(path) do
  #   0
  #   |> IO.inspect(label: path)
  # end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt")
    # part_1("inputs/day#{@day}_input.txt")
    #
    # IO.inspect("part 2")
    # part_2("inputs/day#{@day}_example.txt")
    # part_2("inputs/day#{@day}_input.txt")
  end

  def do_dijkstra(state) do
    %{
      distances: distances,
      current_pos: current_pos,
      visited: visited
    } = state

    points_around = map
    |> Aoc.Map.cell_adjacents(start_pos)
    |> Enum.filter(fn {_, value} -> value != "#" end)
    |> Enum.map(fn {pos, _} -> pos end)

    distances = Enum.reduce(points_around, distances, fn point, distance ->
      Map.set()
    end)
  end

  def dijkstra(map, start_pos, end_pos) do
    state = %{
      distances: %{
        start_pos => 0
      },
      current_pos: start_pos,
      visited: MapSet.new([start_pos])
    }
    do_dijkstra(state)
  end
end
