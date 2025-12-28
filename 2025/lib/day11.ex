defmodule Aoc.Day11 do
  @day "11"

  def part_1(path) do
    path
    |> parse_graph()
    |> count_paths("you", "out")
    |> elem(0)
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    graph = parse_graph(path)

    {svr_to_fft, _cache} = count_paths(graph, "svr", "fft")
    {fft_to_dac, _cache} = count_paths(graph, "fft", "dac")
    {dac_to_out, _cache} = count_paths(graph, "dac", "out")

    IO.inspect(svr_to_fft * fft_to_dac * dac_to_out, label: path)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt")
    part_1("inputs/day#{@day}_input.txt")

    IO.inspect("part 2")
    part_2("inputs/day#{@day}_example2.txt")
    part_2("inputs/day#{@day}_input.txt")
  end

  defp count_paths(_graph, node, _end_node, cache \\ %{})
  defp count_paths(_graph, node, node, cache), do: {1, cache}

  defp count_paths(graph, current_node, end_node, cache) do
    key = {current_node, end_node}
    if Map.has_key?(cache, key) do
      count = Map.get(cache, key)
      {count, cache}
    else
      {count, cache} =
        graph
        |> Map.get(current_node, [])
        |> Enum.reduce({0, cache}, fn node, {current_count, cache} ->
          {count, cache} = count_paths(graph, node, end_node, cache)
          {current_count + count, cache}
        end)

      {count, Map.put(cache, key, count)}
    end
  end

  defp parse_graph(path) do
    path
    |> Aoc.Parser.lines()
    |> Enum.reduce(%{}, fn line, map ->
      [key, value] = String.split(line, ": ")
      Map.put(map, key, String.split(value, " "))
    end)
  end
end
