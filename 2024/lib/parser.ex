defmodule Aoc.Parser do
  def read_file(path) do
    File.read!(path)
  end

  def two_chunks(path) do
    path
    |> File.read!()
    |> String.split("\n\n")
  end

  def numbers_on_lines(path) do
    path
    |> File.stream!()
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def map(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Aoc.Map.new()
  end
end
