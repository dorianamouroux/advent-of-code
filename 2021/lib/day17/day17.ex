defmodule Day17 do
  def main(input) do
    {x, y} = parse(input)

    successful_launches = for inital_x <- 1..Enum.max(x), inital_y <- -100..100 do
      {success, path} = throw_probe({inital_x, inital_y}, {0, 0}, {x, y}, [])
      if success, do: Enum.reverse(path), else: nil
    end
    |> Enum.reject(&is_nil/1)

    successful_launches
    |> Enum.count()
    |> IO.inspect(label: "Number successful launches")

    successful_launches
    |> Enum.max_by(&find_higher_y/1)
    |> find_higher_y()
    |> IO.inspect(label: "The one with highest y")
  end

  def find_higher_y(path) do
    {_, y} = Enum.max_by(path, fn {_, pos_y} -> pos_y end)
    y
  end

  def throw_probe({speed_x, speed_y}, {pos_x, pos_y}, target, path) do
    new_pos = {pos_x + speed_x, pos_y + speed_y}
    path = [new_pos | path]

    cond do
      in_target?(new_pos, target) ->
        {true, path}

      missed_target?({speed_x, speed_y}, new_pos, target) ->
        {false, path}

      true ->
        new_speed = {apply_drag(speed_x), speed_y - 1}
        throw_probe(new_speed, new_pos, target, path)
    end
  end

  def in_target?({pos_x, pos_y}, {[from_x, to_x], [from_y, to_y]}) do
    pos_x in from_x..to_x and pos_y in from_y..to_y
  end

  def missed_target?({_, speed_y}, {_, pos_y}, {_, target_y}) do
    lowest_point = Enum.min(target_y)
    # we keep falling, and we are under the lowest point
    speed_y < 0 and pos_y < lowest_point
  end

  def apply_drag(speed) when speed > 0, do: speed - 1
  def apply_drag(0), do: 0
  def apply_drag(speed) when speed < 0, do: speed + 1

  defp parse("target area: " <> input) do
    ["x=" <> x, "y=" <> y] =
      input
      |> String.trim()
      |> String.split(", ")

    Enum.map([x, y], fn coord ->
      coord
      |> String.split("..")
      |> Enum.map(&String.to_integer/1)
    end)
    |> List.to_tuple()
  end
end
