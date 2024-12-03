defmodule Aoc.Parser do
  def numbers_on_lines(path) do
    path
    |> File.stream!()
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
