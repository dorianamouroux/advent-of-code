defmodule Day13.Part2 do
  alias Day13.Part2.Parsing

  def main(input) do
    {points, folds} = Parsing.read_file(input)

    points
    |> apply_folds(folds)
    |> print()
  end

  def apply_folds(points, folds) do
    Enum.reduce(folds, points, fn fold, points ->
      for point <- points, into: MapSet.new(), do: apply_fold(point, fold)
    end)
  end

  def print(points) do
    {max_x, _} = Enum.max_by(points, fn {x, _} -> x end)
    {_, max_y} = Enum.max_by(points, fn {_, y} -> y end)

    for y <- 0..max_y do
      IO.puts(
        Enum.join(
          for x <- 0..max_x do
            if MapSet.member?(points, {x, y}), do: "# ", else: ". "
          end
        )
      )
    end
  end

  def apply_fold({x, y}, "y=" <> line) do
    line = String.to_integer(line)

    if y > line do
      diff = abs(y - line)
      {x, line - diff}
    else
      {x, y}
    end
  end

  def apply_fold({x, y}, "x=" <> line) do
    line = String.to_integer(line)

    if x > line do
      diff = abs(x - line)
      {line - diff, y}
    else
      {x, y}
    end
  end
end

defmodule Day13.Part2.Parsing do
  def read_file(input) do
    file_content = String.split(input, "\n", trim: true)

    folds =
      file_content
      |> Enum.map(&extract_folding_instruction/1)
      |> Enum.reject(&is_nil/1)

    points =
      file_content
      |> Enum.drop(-Enum.count(folds))
      |> points_to_mapset()

    {points, folds}
  end

  defp points_to_mapset(points) do
    for point <- points, into: MapSet.new() do
      [x, y] = String.split(point, ",", trim: true)
      {String.to_integer(x), String.to_integer(y)}
    end
  end

  defp extract_folding_instruction("fold along " <> fold_part), do: fold_part
  defp extract_folding_instruction(_), do: nil
end
