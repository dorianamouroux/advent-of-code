defmodule Aoc.Day14 do
  @day "14"

  def part_1(path, width, height) do
    robots = parse(path)

    robots
    |> run_cycles(100, width, height)
    |> compute_score(width, height)
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    robots = parse(path)

    1..99999999999999
    |> Enum.find(fn i ->
      new_robots = run_cycles(robots, i, 101, 103)
      check_unique(new_robots)
    end)
    |> tap(fn i ->
      robots
      |> run_cycles(i, 101, 103)
      |> print(101, 103)
    end)
    |> IO.inspect(label: path)
  end

  def check_unique([], map), do: true
  def check_unique([robot | rest_robots], robot_dict \\ %{}) do
    if Map.has_key?(robot_dict, robot) do
      false
    else
      check_unique(rest_robots, Map.put(robot_dict, robot, true))
    end
  end

  def run_cycles(robots, nb_cycles, width, height) do
    Enum.map(robots, fn [x, y, vx, vy] ->
      new_x = x + ((vx + width) * nb_cycles)
      new_y = y + ((vy + height) * nb_cycles)
      {rem(new_x, width), rem(new_y, height)}
    end)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt", 11, 7)
    part_1("inputs/day#{@day}_input.txt", 101, 103)

    IO.inspect("part 2")
    part_2("inputs/day#{@day}_input.txt")
  end

  defp compute_score(robots, width, height) do
    line_x = floor(width / 2)
    line_y = floor(height / 2)

    robots
    |> Enum.group_by(fn {x, y} ->
      cond do
        x < line_x && y < line_y -> 0
        x > line_x && y < line_y -> 1
        x < line_x && y > line_y -> 2
        x > line_x && y > line_y -> 3
        true -> nil
      end
    end)
    |> Enum.map(fn
      {nil, _robots} -> 1
      {_quadrant, robots} -> Enum.count(robots)
    end)
    |> Enum.product()
  end

  defp print(robots, width, height) do
    for y <- 0..(height - 1) do
      for x <- 0..(width - 1) do
        c = robots
        |> Enum.filter(fn {a, b} -> a == x && b == y end)
        |> Enum.count()

        IO.write(if(c > 0, do: c, else: "."))
      end
      IO.write("\n")
    end
    robots
  end

  defp parse(path) do
    path
    |> Aoc.Parser.lines()
    |> Enum.map(&Aoc.Parser.numbers_on_string/1)
  end
end
