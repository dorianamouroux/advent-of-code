defmodule Day14.Part2 do
  @nb_step 40
  def main(input) do
    {initial, mappings} = Day14.Part2.Parsing.read_file(input)

    initial
    |> string_to_map_count()
    |> apply_step(mappings, @nb_step)
    |> count_result(String.first(initial))
    |> Enum.min_max_by(fn {_, nb} -> nb end)
    |> then(fn {{_, count_min}, {_, count_max}} -> count_max - count_min end)
    |> IO.inspect()
  end

  # "NNCB" => %{NN => 1, NC => 1, CB => 1}
  def string_to_map_count(initial) do
    initial
    |> String.split("", trim: true)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&Enum.join/1)
    |> Enum.frequencies()
  end

  # %{NN => 1, NC => 1, CB => 1}, "N" -> %{N: 2, C: 1, B: 1}
  def count_result(current, first_char) do
    Enum.reduce(current, Map.put(%{}, first_char, 1), fn {pair, count}, total ->
      right_letter = String.last(pair)
      Map.update(total, right_letter, count, &(&1 + count))
    end)
  end

  def apply_step(current, _, 0), do: current

  def apply_step(current, mappings, step) do
    current
    |> Enum.reduce(%{}, fn {pair, nb}, total ->
      new_letter = Map.get(mappings, pair)

      total
      |> Map.update(String.first(pair) <> new_letter, nb, &(&1 + nb))
      |> Map.update(new_letter <> String.last(pair), nb, &(&1 + nb))
    end)
    |> apply_step(mappings, step - 1)
  end
end

defmodule Day14.Part2.Parsing do
  def read_file(input) do
    file_content = String.split(input, "\n", trim: true)

    [initial | mappings] = file_content
    {initial, parse_mapping(mappings)}
  end

  defp parse_mapping(mappings) do
    for mapping <- mappings, into: %{} do
      mapping |> String.split(" -> ") |> List.to_tuple()
    end
  end
end
