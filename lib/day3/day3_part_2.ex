defmodule Day3.Part2 do
  def main(input) do
    readings = read_file(input)
    oxygen = find_x_common_value(readings, 0, &most_common_value/2)
    co2 = find_x_common_value(readings, 0, &least_common_value/2)
    IO.inspect(oxygen * co2)
  end

  defp find_x_common_value([reading], _, _), do: binary_to_int(reading)

  defp find_x_common_value(all_readings, pos, comparer) do
    {nb_zeros, nb_ones} = nb_values_at_pos(all_readings, pos)
    x_common_value_pos = comparer.(nb_ones, nb_zeros)

    all_readings
    |> Enum.filter(&(String.at(&1, pos) == x_common_value_pos))
    |> find_x_common_value(pos + 1, comparer)
  end

  def most_common_value(nb_ones, nb_zeros), do: if(nb_ones >= nb_zeros, do: "1", else: "0")
  def least_common_value(nb_ones, nb_zeros), do: if(nb_ones >= nb_zeros, do: "0", else: "1")

  defp nb_values_at_pos(readings, pos) do
    nb_ones =
      readings
      |> Enum.map(&String.at(&1, pos))
      |> Enum.filter(&(&1 == "1"))
      |> Enum.count()

    {Enum.count(readings) - nb_ones, nb_ones}
  end

  defp binary_to_int(number) do
    {value, _} = Integer.parse(number, 2)
    value
  end

  defp read_file(input) do
    input
    |> String.split("\n")
    |> Enum.filter(fn line -> line != "" end)
  end
end
