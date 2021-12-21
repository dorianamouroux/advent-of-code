defmodule Day20 do

  def main(input) do
    {image, algo} = parse(input)

    image
    |> enhance_times(algo, 2)
    |> IO.inspect(label: "After two times")

    image
    |> enhance_times(algo, 50)
    |> IO.inspect(label: "After 50 times")
  end

  def enhance_times(image, _, 0) do
    Enum.count(image, fn {_, pixel} -> pixel == "#" end)
  end

  def enhance_times(image, algo, n) do
    default = if rem(n, 2) == 1, do: elem(algo, 0), else: "."
    image = enhance(image, algo, default)
    enhance_times(image, algo, n - 1)
  end

  def enhance(image, algo, default) do
    image
    |> get_coords_image()
    |> Enum.reduce(%{}, fn pos, finished_image ->
      value_enhanment = get_value_for_enhancement(image, pos, default)
      new_pixel = elem(algo, value_enhanment)
      Map.put(finished_image, pos, new_pixel)
    end)
  end

  def get_coords_image(image) do
    coords = Map.keys(image)
    {min_x, max_x} = coords
    |> Enum.map(fn {x, _} -> x end)
    |> Enum.min_max()

    {min_y, max_y} = coords
    |> Enum.map(fn {_, y} -> y end)
    |> Enum.min_max()

    for y <- min_y - 1..max_y + 1, x <- min_x - 1..max_x + 1 do
      {x, y}
    end
  end

  def get_value_for_enhancement(image, {x, y}, default) do
    Enum.join([
      Map.get(image, {x - 1, y - 1}, default),
      Map.get(image, {x, y - 1}, default),
      Map.get(image, {x + 1, y - 1}, default),
      Map.get(image, {x - 1, y}, default),
      Map.get(image, {x, y}, default),
      Map.get(image, {x + 1, y}, default),
      Map.get(image, {x - 1, y + 1}, default),
      Map.get(image, {x, y + 1}, default),
      Map.get(image, {x + 1, y + 1}, default),
    ])
    |> String.replace(".", "0")
    |> String.replace("#", "1")
    |> String.to_integer(2)
  end

  def parse(input) do
    [algo, image] = String.split(input, "\n\n")

    image = image
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, "", trim: true) end)

    image = for {line, y} <- Enum.with_index(image), {pixel, x} <- Enum.with_index(line), into: %{} do
      {{x, y}, pixel}
    end

    algo = algo
    |> String.replace("\n", "")
    |> String.split("", trim: true)
    |> List.to_tuple()

    {image, algo}
  end
end
