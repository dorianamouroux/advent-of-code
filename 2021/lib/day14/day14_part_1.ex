defmodule Day14.Part1 do
  @nb_step 10

  def main(input) do
    {initial, mapping} = Day14.Part1.Parsing.read_file(input)

    after_x_step =
      Enum.reduce(1..@nb_step, initial, fn _, current ->
        apply_step(current, mapping)
      end)

    after_x_step
    |> String.split("", trim: true)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.min_max()
    |> then(fn {min, max} -> max - min end)
    |> IO.inspect()
  end

  def apply_step(current, mapping) do
    last_letter = String.last(current)

    current
    |> String.split("", trim: true)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&insert_elem(&1, mapping))
    |> Enum.join()
    |> Kernel.<>(last_letter)
  end

  def insert_elem([left, right], mapping) do
    middle = Map.get(mapping, left <> right)
    left <> middle
  end
end

defmodule Day14.Part1.Parsing do
  def read_file(input) do
    file_content = String.split(input, "\n", trim: true)

    [initial | mappings] = file_content
    {initial, to_map(mappings)}
  end

  def to_map(mappings) do
    for mapping <- mappings, into: %{} do
      mapping |> String.split(" -> ") |> List.to_tuple()
    end
  end
end
