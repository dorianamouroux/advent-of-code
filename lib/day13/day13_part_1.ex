defmodule Day13.Part1 do
  def main() do
    {points, folds} = Parsing.read_file()

    points
    |> apply_folds(folds)
    |> Enum.count()
    |> IO.inspect()
  end

  def apply_folds(points, folds) do
    folds
    |> Enum.take(1)
    |> Enum.reduce(points, fn fold, points ->
      for point <- points, into: MapSet.new(), do: apply_fold(point, fold)
    end)
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

defmodule Parsing do
  def read_file() do
    [filename] = System.argv()

    file_content =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)

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
