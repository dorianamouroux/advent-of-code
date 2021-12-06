defmodule Day6 do

  def main() do
    initial_fishes = read_file()

    1..18
    |> Enum.reduce(initial_fishes, fn _, fishes ->
      IO.inspect(Enum.frequencies(fishes))
      nb_new_fishes = Enum.count(fishes, & &1 == 0)
      fishes
      |> apply_fish_cycle()
      |> Kernel.++(List.duplicate(8, nb_new_fishes))
    end)
    |> Enum.count()
    |> IO.inspect()
  end

  def apply_fish_cycle(fishes) do
    Enum.map(fishes, fn
      0 -> 6
      fish -> fish - 1
    end)
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
