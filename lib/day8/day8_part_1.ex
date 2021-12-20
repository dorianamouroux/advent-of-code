defmodule Day8.Part1 do
  def main() do
    readings = read_file()

    readings
    |> List.flatten()
    |> Enum.filter(fn word ->
      len = String.length(word)
      Enum.member?([2, 3, 4, 7], len)
    end)
    |> Enum.count()
    |> IO.inspect()
  end

  defp read_file() do
    [filename] = System.argv()

    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, second_part] = String.split(line, "|")

      second_part
      |> String.split(" ")
    end)
  end
end
