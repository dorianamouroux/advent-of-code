defmodule Day1.Part1 do
  def main(input) do
    measurements = read_file(input)

    measurements
    |> analyze_data()
    |> Enum.filter(fn data -> data == :increased end)
    |> Enum.count()
    |> IO.inspect()
  end

  defp analyze_data(measurements) do
    analyze = []
    compare_with_previous(measurements, nil, analyze)
  end

  defp compare_with_previous([], _, analyze) do
    analyze
  end

  defp compare_with_previous([current | rest], previous, analyze) do
    analyzed_row =
      case {current, previous} do
        {_, nil} -> :no_previous
        {current, previous} when current < previous -> :decreased
        {current, previous} when current > previous -> :increased
        _ -> :same
      end

    compare_with_previous(rest, current, [analyzed_row | analyze])
  end

  defp read_file(input) do
    input
    |> String.split("\n")
    |> Enum.filter(fn line -> line != "" end)
    |> Enum.map(fn line ->
      {number, _} = Integer.parse(line)
      number
    end)
  end
end
