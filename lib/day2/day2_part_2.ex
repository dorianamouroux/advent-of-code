defmodule Day2 do

  def main() do
    steps = read_file()
    {position, depth, aim} = run_steps(steps, 0, 0, 0)

    IO.inspect("position = #{position}")
    IO.inspect("depth = #{depth}")
    IO.inspect("horizon position = #{depth * position}")
  end

  def run_steps([], position, depth, aim) do
    {position, depth, aim}
  end

  def run_steps([current_step | next_steps], position, depth, aim) do
    {position, depth, aim} = case current_step do
      {"forward", size} -> {position + size, depth + (aim * size), aim}
      {"up", size} -> {position, depth, aim - size}
      {"down", size} -> {position, depth, aim + size}
    end

    run_steps(next_steps, position, depth, aim)
  end

  defp read_file() do
    [filename] = System.argv()
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(fn line -> line != "" end)
    |> Enum.map(fn line ->
      [action, size] = String.split(line, " ")
      {size, _} = Integer.parse(size)
      {action, size}
    end)
  end

end

Day2.main()
