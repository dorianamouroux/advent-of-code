defmodule Aoc.Day06 do
  @day "06"
  @direction %{
    left: [-1, 0],
    up: [0, -1],
    right: [1, 0],
    down: [0, 1],
  }

  def part_1(path) do
    input = Aoc.Parser.map(path)

    context = move_until_out(%{
      current_pos: Aoc.Map.find(input, "^"),
      visited: MapSet.new([]),
      direction: :up,
      map: input
    })

    context
    |> pos_visited()
    |> Enum.count()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    input = Aoc.Parser.map(path)
    initial_context = %{
      current_pos: Aoc.Map.find(input, "^"),
      visited: MapSet.new([]),
      direction: :up,
      map: input
    }

    initial_context
    |> move_until_out()
    |> pos_visited() # only add obstacles on the paths of the original circuit
    |> Enum.reject(& &1 == initial_context.current_pos)
    |> Task.async_stream(fn {x, y} ->
      updated_map = Aoc.Map.put(initial_context.map, x, y, "#")

      outcome = initial_context
      |> Map.put(:map, updated_map)
      |> move_until_out()
      |> Map.get(:outcome)

      outcome == :loop
    end)
    |> Enum.count(fn {:ok, result} -> result end)
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

  defp move_until_out(context) do
    {x, y} = context.current_pos
    [modifier_x, modifier_y] = @direction[context.direction]
    already_visited? = Enum.member?(context.visited, {context.current_pos, context.direction})
    context = set_visited(context)
    next_cell = Aoc.Map.at(context.map, x + modifier_x, y + modifier_y)

    cond do
      already_visited? ->
        Map.put(context, :outcome, :loop)
      next_cell == nil ->
        Map.put(context, :outcome, :finished)
      next_cell == "#" ->
        context
        |> Map.put(:direction, rotate(context.direction))
        |> move_until_out()
      true  ->
        context
        |> Map.put(:current_pos, {x + modifier_x, y + modifier_y})
        |> move_until_out()
    end
  end

  defp set_visited(context) do
    visit = {context.current_pos, context.direction}

    Map.put(context, :visited, MapSet.put(context.visited, visit))
  end

  defp pos_visited(context) do
    context.visited
    |> Enum.map(fn {pos, _direction} -> pos end)
    |> MapSet.new()
  end

  defp rotate(:down), do: :left
  defp rotate(:left), do: :up
  defp rotate(:up), do: :right
  defp rotate(:right), do: :down
end
