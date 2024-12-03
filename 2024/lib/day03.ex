defmodule Aoc.Day03 do
  @day "03"

  def part_1(path) do
    path
    |> Aoc.Parser.read_file()
    |> execute_memory()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    regex_between_dont_and_do = ~r/don't\(\).*?do\(\)/s

    path
    |> Aoc.Parser.read_file()
    |> Kernel.<>("do()") # Always finish the memory with a do(), so the regex can capture the last dont()
    |> String.replace(regex_between_dont_and_do, "")
    |> execute_memory()
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

  defp execute_memory(memory) do
    ~r/mul\((\d+),(\d+)\)/
    |> Regex.scan(memory)
    |> Enum.map(fn [_, left, right] ->
      String.to_integer(left) * String.to_integer(right)
    end)
    |> Enum.sum()
  end
end
