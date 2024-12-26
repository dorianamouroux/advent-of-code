defmodule Aoc.Day09 do
  @day "09"

  require Integer

  def part_1(path) do
    memory = path
    |> read_file()
    |> Enum.with_index()
    |> Enum.map(fn {id, index} ->
      cell = if Integer.is_even(index), do: round(index / 2), else: :empty
      {cell, id}
    end)

    memory
    |> compact_p1(Enum.count(memory) - 1)
    |> compute_score(0, 0)
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    memory = path
    |> read_file()
    |> Enum.with_index()
    |> Enum.map(fn {id, index} ->
      cell = if Integer.is_even(index), do: round(index / 2), else: :empty
      {cell, id}
    end)

    memory
    |> compact_p2(Enum.count(memory) - 1)
    |> compute_score(0, 0)
    |> IO.inspect(label: path)
  end

  def compact_p1(memory, 0), do: memory
  def compact_p1(memory, i) do
    case Enum.at(memory, i) do
      {:empty, _amount} -> compact_p1(memory, i - 1)
      {id, amount} ->
        pos = Enum.find_index(memory, fn {cell, amount} -> cell == :empty && amount > 0 end)

        if pos < i do
          {_, empty_space} = Enum.at(memory, pos)

          memory
          |> List.replace_at(i, if(amount == 1, do: [], else: [{id, amount - 1}, {:empty, amount}]))
          |> List.replace_at(pos, [{id, 1}, {:empty, empty_space - 1}])
          |> List.flatten()
          |> compact_p1(i + 1)
        else
          compact_p1(memory, i - 1)
        end
    end
  end

  def compact_p2(memory, 0), do: memory
  def compact_p2(memory, i) do
    case Enum.at(memory, i) do
      {:empty, _amount} -> compact_p2(memory, i - 1)
      {id, amount} ->
        pos_empty = Enum.find_index(memory, fn {cell, size_empty} ->
          cell == :empty && size_empty >= amount
        end)

        if pos_empty < i do
          {_, empty_space} = Enum.at(memory, pos_empty)

          memory
          |> List.replace_at(pos_empty, [{id, amount}, {:empty, empty_space - amount}])
          |> List.replace_at(i, {:empty, amount})
          |> List.flatten()
          |> compact_p2(i)
        else
          compact_p2(memory, i - 1)
        end
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

  defp compute_score([], _i, score), do: score
  defp compute_score([{:empty, amount} | rest], i, score) do
    compute_score(rest, i + amount, score)
  end
  defp compute_score([{id, amount} | rest], i, score) do
    extra_score = 0..(amount - 1)
    |> Enum.map(fn n -> (n + i) * id end)
    |> Enum.sum()

    compute_score(rest, i + amount, score + extra_score)
  end

  defp read_file(path) do
    path
    |> Aoc.Parser.read_file()
    |> String.replace("\n", "")
    |> String.split("")
    |> Enum.reject(& &1 == "")
    |> Enum.map(&String.to_integer/1)
  end
end
