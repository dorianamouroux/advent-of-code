defmodule Day7.Part2 do
  def main(input) do
    positions = read_file(input)

    {min_pos, max_pos} = Enum.min_max(positions)

    min_pos..max_pos
    |> Enum.map(&get_fuel(&1, positions))
    |> Enum.min()
    |> IO.inspect()
  end

  def get_fuel(pos, positions) do
    positions
    |> Enum.map(fn crab_pos ->
      diff = abs(crab_pos - pos)
      trunc(diff * (diff + 1) / 2)
    end)
    |> Enum.sum()
  end

  defp read_file(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
