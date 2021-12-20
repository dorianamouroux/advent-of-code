defmodule Day8.Part2 do
  def main() do
    readings = Parsing.read_file()

    readings
    |> Enum.map(fn [models, numbers] ->
      word_to_number = Model.analyze(models)

      numbers
      |> Enum.map(&find_number(word_to_number, &1))
      |> Enum.join()
      |> String.to_integer()
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  def find_number(models, number) do
    {_, number} = Enum.find(models, fn {set, _} -> MapSet.equal?(set, number) end)
    number
  end
end

defmodule Model do
  def analyze(models) do
    one = get_number_with_size(models, 2)
    seven = get_number_with_size(models, 3)
    four = get_number_with_size(models, 4)
    eight = get_number_with_size(models, 7)

    models =
      models
      |> exclude_known_letter(one)
      |> exclude_known_letter(seven)
      |> exclude_known_letter(four)
      |> exclude_known_letter(eight)

    top_segment = MapSet.difference(seven, one) |> Enum.at(0)
    bottom_segment = get_missing_segment(models, MapSet.put(four, top_segment))

    nine = four |> MapSet.put(top_segment) |> MapSet.put(bottom_segment)

    models = exclude_known_letter(models, nine)

    zero =
      models
      |> get_numbers_with_size(6)
      |> Enum.find(&MapSet.subset?(one, &1))

    models = exclude_known_letter(models, zero)

    six = get_number_with_size(models, 6)

    models = exclude_known_letter(models, six)

    three = Enum.find(models, &MapSet.subset?(one, &1))

    models = exclude_known_letter(models, three)

    five = Enum.find(models, &MapSet.subset?(&1, six))

    models = exclude_known_letter(models, five)

    [two] = models

    [
      {zero, "0"},
      {one, "1"},
      {two, "2"},
      {three, "3"},
      {four, "4"},
      {five, "5"},
      {six, "6"},
      {seven, "7"},
      {eight, "8"},
      {nine, "9"}
    ]
  end

  def exclude_known_letter(models, letter) do
    Enum.reject(models, &MapSet.equal?(&1, letter))
  end

  def get_missing_segment(models, letter) do
    models
    |> get_numbers_with_size(MapSet.size(letter) + 1)
    |> Enum.find(fn model -> MapSet.subset?(letter, model) end)
    |> MapSet.difference(letter)
    |> Enum.at(0)
  end

  def get_numbers_with_size(models, size) do
    Enum.filter(models, &(MapSet.size(&1) == size))
  end

  def get_number_with_size(models, size) do
    get_numbers_with_size(models, size) |> Enum.at(0)
  end
end

defmodule Parsing do
  def read_file() do
    [filename] = System.argv()

    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split(" | ")
    |> Enum.map(&parse_list_nb/1)
  end

  defp parse_list_nb(list) do
    list
    |> String.split(" ", trim: true)
    |> Enum.map(&(&1 |> String.split("", trim: true) |> MapSet.new()))
  end
end
