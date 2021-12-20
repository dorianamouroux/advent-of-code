defmodule Day9.Part1 do
  def main() do
    grid = read_file()

    height = grid |> Enum.count()
    width = grid |> Enum.at(0) |> Enum.count()

    number_smaller_than_adjacent =
      for y <- 0..height do
        for x <- 0..width do
          current = get_at_pos(grid, x, y)

          if is_smaller_than_adjacent(grid, current, x, y) do
            current
          else
            nil
          end
        end
      end
      |> List.flatten()
      |> Enum.reject(&is_nil/1)

    number_smaller_than_adjacent
    |> Enum.sum()
    |> Kernel.+(Enum.count(number_smaller_than_adjacent))
    |> IO.inspect()
  end

  def is_smaller_than_adjacent(grid, number, x, y) do
    left = get_at_pos(grid, x - 1, y)
    right = get_at_pos(grid, x + 1, y)
    above = get_at_pos(grid, x, y - 1)
    below = get_at_pos(grid, x, y + 1)

    Enum.all?([left, right, above, below], &(number < &1))
  end

  # using 9999 as a large number so if out of grid, it won't count
  def get_at_pos(_grid, x, _y) when x < 0, do: 9999
  def get_at_pos(_grid, _x, y) when y < 0, do: 9999

  def get_at_pos(grid, x, y) do
    case Enum.at(grid, y, []) do
      line -> Enum.at(line, x, 9999)
    end
  end

  defp read_file() do
    [filename] = System.argv()

    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
