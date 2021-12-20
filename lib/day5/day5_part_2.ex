defmodule Day5.Part2 do
  alias Day5.Part2.Parsing
  alias Day5.Part2.Canvas

  def main(input) do
    vectors = Parsing.read_file(input)

    canvas_with_vectors = Canvas.draw_vectors(vectors)

    canvas_with_vectors
    |> Enum.map(fn {_, nb_overlap} -> nb_overlap end)
    |> Enum.filter(&(&1 >= 2))
    |> Enum.count()
    |> IO.inspect()
  end
end

defmodule Day5.Part2.Canvas do
  def draw_vectors(vectors) do
    Enum.reduce(vectors, %{}, fn vector, canvas ->
      draw_vector(canvas, vector)
    end)
  end

  def draw_vector(canvas, vector) do
    {{x, y}, {x2, y2}} = vector

    case {x, y, x2, y2} do
      {_, y, _, y2} when y == y2 -> draw_horizontal(canvas, vector)
      {x, _, x2, _} when x == x2 -> draw_vertically(canvas, vector)
      {x, y, x2, y2} when abs(x2 - x) == abs(y2 - y) -> draw_diagonal(canvas, vector)
      _ -> canvas
    end
  end

  def draw_horizontal(canvas, vector) do
    {{x, y}, {x2, _}} = vector

    range = if(x < x2, do: x..x2, else: x2..x)

    Enum.reduce(range, canvas, fn pos_x, canvas ->
      draw_point(canvas, pos_x, y)
    end)
  end

  def draw_vertically(canvas, vector) do
    {{x, y}, {_, y2}} = vector

    range = if(y < y2, do: y..y2, else: y2..y)

    Enum.reduce(range, canvas, fn pos_y, canvas ->
      draw_point(canvas, x, pos_y)
    end)
  end

  def draw_diagonal(canvas, vector) do
    {{x, y}, {x2, y2}} = vector

    range_y = if(y < y2, do: y..y2, else: y2..y)
    range_x = if(x < x2, do: x..x2, else: x2..x)

    Enum.reduce(range_y, canvas, fn pos_y, canvas ->
      Enum.reduce(range_x, canvas, fn pos_x, canvas ->
        if abs(pos_x - x) == abs(pos_y - y) do
          draw_point(canvas, pos_x, pos_y)
        else
          canvas
        end
      end)
    end)
  end

  def draw_point(canvas, x, y) do
    position = "#{x}-#{y}"
    current = Map.get(canvas, position, 0)
    Map.put(canvas, position, current + 1)
  end
end

defmodule Day5.Part2.Parsing do
  def read_file(input) do
    raw_file(input)
    |> Enum.map(&parse_to_vector/1)
  end

  defp parse_to_vector(line) do
    [start_v, end_v] =
      line
      |> String.split("->")
      |> Enum.map(&parse_points/1)

    {start_v, end_v}
  end

  defp parse_points(point) do
    [left, right] =
      point
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&binary_to_int/1)

    {left, right}
  end

  defp raw_file(input) do
    input
    |> String.split("\n")
    |> Enum.filter(fn line -> line != "" end)
  end

  defp binary_to_int(number) do
    {value, _} = Integer.parse(number, 10)
    value
  end
end
