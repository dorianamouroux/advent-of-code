defmodule Day25 do

  def main(input) do
    {map, width, height} = parse(input)

    Stream.iterate(1, & &1 + 1)
    |> Enum.reduce_while(map, fn step, map ->
      new_map = one_cycle(map, width, height)
      if map == new_map do
        {:halt, step}
      else
        {:cont, new_map}
      end
    end)
    |> IO.inspect()
  end

  def print(map, width, height) do
    for y <- 0..height - 1 do
      for x <- 0..width - 1 do
        Map.get(map, {x, y}, ".")
      end
      |> IO.puts()
    end
  end

  def one_cycle(map, width, height) do
    {east_cucumbers, south_cucumbers} = map
    |> Map.to_list()
    |> Enum.split_with(fn {_, letter} -> letter == ">" end)

    map
    |> apply_transition(east_cucumbers, fn {x, y} -> {rem(x + 1, width), y} end)
    |> apply_transition(south_cucumbers, fn {x, y} -> {x, rem(y + 1, height)} end)
  end

  def apply_transition(map, cucumbers, transition_fn) do
    Enum.reduce(cucumbers, map, fn {pos, letter}, new_map ->
      new_pos = transition_fn.(pos)
      if Map.has_key?(map, new_pos) do
        new_map # busy
      else
        new_map
        |> Map.put(new_pos, letter)
        |> Map.delete(pos)
      end
    end)
  end

  def parse(input) do
    dbl_list = input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))

    height = Enum.count(dbl_list)
    width = Enum.count(Enum.at(dbl_list, 0))

    as_map = for {line, y} <- Enum.with_index(dbl_list), {letter, x} <- Enum.with_index(line), letter != ".", into: %{} do
      {{x, y}, letter}
    end

    {as_map, width, height}
  end
end
