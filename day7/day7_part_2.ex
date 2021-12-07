defmodule Day7 do

  def main() do
    positions = read_file()

    {min_pos, max_pos} = Enum.min_max(positions)

    min_pos..max_pos
    |> Enum.map(& get_fuel(&1, positions))
    |> Enum.min()
    |> IO.inspect
  end

  def get_fuel(pos, positions) do
    positions
    |> Enum.map(fn crab_pos ->
      diff = abs(crab_pos - pos)
      trunc(diff * (diff + 1) / 2)
    end)
    |> Enum.sum()
  end

  defp read_file() do
    [filename] = System.argv()
    filename
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end

Day7.main()
