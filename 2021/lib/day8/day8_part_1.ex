defmodule Day8.Part1 do
  def main(input) do
    readings = read_file(input)

    readings
    |> List.flatten()
    |> Enum.filter(fn word ->
      len = String.length(word)
      Enum.member?([2, 3, 4, 7], len)
    end)
    |> Enum.count()
    |> IO.inspect()
  end

  defp read_file(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, second_part] = String.split(line, "|")

      second_part
      |> String.split(" ")
    end)
  end
end
