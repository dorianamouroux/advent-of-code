defmodule Aoc.Day02 do
  @day "02"

  def part_1(path) do
    path
    |> Aoc.Parser.numbers_on_lines()
    |> Enum.count(&is_report_safe?/1)
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    path
    |> Aoc.Parser.numbers_on_lines()
    |> Enum.count(fn report ->
      is_report_safe?(report) || is_report_safe_with_tolerance?(report)
    end)
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

  defp is_report_safe?(report) do
    is_diff_between_numbers_good? =
      report
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.all?(fn [prev, current] ->
        diff = abs(prev - current)
        diff > 0 && diff <= 3
      end)

    is_ordered? = Enum.sort(report) == report || Enum.sort(report, :desc) == report

    (is_diff_between_numbers_good? && is_ordered?)
  end

  defp is_report_safe_with_tolerance?(report) do
    # brutforce by remove one elem of the report and trying again
    Enum.any?(0..(length(report) - 1), fn pos ->
      report
      |> List.delete_at(pos)
      |> is_report_safe?()
    end)
  end
end
