defmodule Day6 do
  @nb_cycle 256

  def main() do
    initial_fishes = read_file() |> Enum.frequencies()

    1..@nb_cycle
    |> Enum.reduce(initial_fishes, fn _, fishes ->
      nb_new_fishes = Map.get(fishes, 0, 0)
      fishes
      |> apply_fish_cycle()
      |> Map.put(8, nb_new_fishes)
      |> Map.update(6, nb_new_fishes, &(&1 + nb_new_fishes))
    end)
    |> Map.values()
    |> Enum.sum()
    |> IO.inspect()
  end

  def apply_fish_cycle(fishes) do
    for {current_cycle, nb_fish} <- fishes, current_cycle > 0, into: %{} do
      {current_cycle - 1, nb_fish}
    end
  end

  defp read_file() do
    [filename] = System.argv()
    filename
    |> File.read!()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end

Day6.main()
