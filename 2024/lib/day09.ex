defmodule Aoc.Day09 do
  @day "09"

  require Integer

  def part_1(path) do
    memory = build_memory(path)
    max_cell = Enum.count(memory)
    nb_memory = Enum.count(memory, fn {_, cell} -> cell != :empty end)

    memory
    |> compact_memory(0, max_cell, 0, nb_memory)
    |> IO.inspect(label: path)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt")
    part_1("inputs/day#{@day}_input.txt")
  end

  defp compact_memory(_memory, check_sum, _max_cell, i, nb_memory) when nb_memory <= i do
    check_sum
  end

  defp compact_memory(memory, check_sum, max_cell, i, nb_memory) do
    {memory, max_cell, memory_cell} = case Map.get(memory, i) do
      :empty ->
        max_cell = find_next_max(memory, max_cell - 1)
        memory_cell = Map.get(memory, max_cell)
        memory = Map.put(memory, max_cell, :empty)
        {memory, max_cell, memory_cell}
      _cell ->
        {memory, max_cell, Map.get(memory, i)}
    end

    check_sum = check_sum + (memory_cell * i)
    compact_memory(memory, check_sum, max_cell, i + 1, nb_memory)
  end

  defp find_next_max(memory, max_cell) do
    if is_integer(Map.get(memory, max_cell)) do
      max_cell
    else
      find_next_max(memory, max_cell - 1)
    end
  end

  defp build_memory(path) do
    path
    |> Aoc.Parser.read_file()
    |> String.replace("\n", "")
    |> String.split("")
    |> Enum.reject(& &1 == "")
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(fn {id, index} ->
      if Integer.is_even(index) do
        List.duplicate(round(index / 2), id)
      else
        List.duplicate(:empty, id)
      end
    end)
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.map(fn {value, key} -> {key, value} end)
    |> Map.new()
  end
end
