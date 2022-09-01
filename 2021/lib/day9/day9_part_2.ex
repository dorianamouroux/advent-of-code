defmodule Day9.Part2 do
  def main(input) do
    grid = read_file(input)

    grid
    |> find_basins()
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.reduce(1, fn acc, total -> acc * total end)
    |> IO.inspect()
  end

  def find_basins(grid), do: find_basins(grid, [])

  def find_basins(grid, basins) do
    case get_pos_of_next_basin(grid) do
      nil ->
        basins

      {x, y} ->
        {grid, basin_size} = extract_basin(grid, x, y, 0)
        find_basins(grid, [basin_size | basins])
    end
  end

  def extract_basin(grid, x, y, basin_count) do
    current = get_at_pos(grid, x, y)

    if current == 9 or current == nil do
      {grid, basin_count}
    else
      grid = put_in(grid, [Access.at(y), Access.at(x)], nil)
      basin_count = basin_count + 1
      {grid, basin_count} = extract_basin(grid, x + 1, y, basin_count)
      {grid, basin_count} = extract_basin(grid, x - 1, y, basin_count)
      {grid, basin_count} = extract_basin(grid, x, y + 1, basin_count)
      extract_basin(grid, x, y - 1, basin_count)
    end
  end

  def get_pos_of_next_basin(grid) do
    y =
      Enum.find_index(grid, fn line ->
        Enum.any?(line, &in_bassin/1)
      end)

    if is_nil(y) do
      nil
    else
      x =
        grid
        |> Enum.at(y)
        |> Enum.find_index(&in_bassin/1)

      {x, y}
    end
  end

  def in_bassin(elem) when is_number(elem) and elem < 9, do: true
  def in_bassin(_), do: false

  # using 9999 as a large number so if out of grid, it won't count
  def get_at_pos(_grid, x, _y) when x < 0, do: nil
  def get_at_pos(_grid, _x, y) when y < 0, do: nil

  def get_at_pos(grid, x, y) do
    case Enum.at(grid, y, []) do
      line -> Enum.at(line, x, nil)
    end
  end

  defp read_file(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
