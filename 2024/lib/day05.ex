defmodule Aoc.Day05 do
  @day "05"

  def part_1(path) do
    [order, updates] = Aoc.Parser.two_chunks(path)
    order = build_order(order)
    updates = build_updates(updates)

    updates
    |> Enum.filter(&is_valid_update(&1, order))
    |> compute_score()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    [order, updates] = Aoc.Parser.two_chunks(path)
    order = build_order(order)
    updates = build_updates(updates)

    updates
    |> Enum.reject(&is_valid_update(&1, order))
    |> Enum.map(&sort_update(&1, order))
    |> compute_score()
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

  defp compute_score(updates) do
    updates
    |> Enum.map(fn update ->
      Enum.at(update, floor(length(update) / 2))
    end)
    |> Enum.sum()
  end

  defp build_order(order) do
    for rule <- String.split(order, "\n") do
      [left, right] = rule
      |> String.split("|")
      |> Enum.map(&String.to_integer/1)

      {left, right}
    end
    |> MapSet.new()
  end

  defp build_updates(updates) do
    updates
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp is_valid_update(update, order) do
    update == sort_update(update, order)
  end

  defp sort_update(update, order) do
    Enum.sort(update, fn a, b ->
      Enum.member?(order, {a, b})
    end)
  end
end
