defmodule Day3 do

  def main() do
    readings = read_file()

    gamma = find_gamma_rate(readings)
    epsilon = reverse_number(gamma)

    IO.inspect(binary_to_int(gamma) * binary_to_int(epsilon))
  end

  defp find_gamma_rate(readings) do
    size_word = String.length(Enum.at(readings, 0))
    nb_input = Enum.count(readings)

    for i <- 0..(size_word - 1) do
      value_at_col = for reading <- readings do
        String.at(reading, i)
      end

      nb_ones = value_at_col
      |> Enum.filter(fn value -> value == "1" end)
      |> Enum.count()

      case nb_ones > (nb_input / 2) do
        true -> "1"
        false -> "0"
      end
    end
  end

  defp reverse_number(number) do
    Enum.map(number, fn
      "1" -> "0"
      "0" -> "1"
    end)
  end

  defp binary_to_int(number) do
    {value, _} = number
    |> Enum.join()
    |> Integer.parse(2)
    value
  end

  defp read_file() do
    [filename] = System.argv()
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(fn line -> line != "" end)
  end

end

Day3.main()
