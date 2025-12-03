defmodule Aoc.Parser do
  def read_file(path) do
    File.read!(path)
  end

  def lines(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
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
      |> String.trim()
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  # def map(path) do
  #   path
  #   |> File.read!()
  #   |> String.split("\n", trim: true)
  #   |> Enum.map(&String.split(&1, "", trim: true))
  #   |> Aoc.Map.new()
  # end

  def numbers_on_string(str) do
    ~r/[\-?0-9]+/
    |> Regex.scan(str)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end
end
