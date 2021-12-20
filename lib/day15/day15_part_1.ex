defmodule Day15.Part1 do
  def main() do
    {grid, width, height} = Day15.Part1.Parsing.read_file()
    bottom_right_pos = {width - 1, height - 1}

    Enum.reduce_while(
      1..300_000,
      %{
        current: {{0, 0}, 0},
        last: nil,
        next_to_visit: [],
        visited: %{}
      },
      fn _, data ->
        nearby_cells = get_nearby_cells(grid, data.current, data.last)

        next_to_visit =
          nearby_cells
          |> Map.new()
          |> Map.merge(Map.new(data.next_to_visit), fn _k, v1, v2 -> Enum.min([v1, v2]) end)
          |> Map.to_list()
          |> Enum.filter(fn {pos, value} -> value < Map.get(data.visited, pos, 99999) end)
          |> Enum.sort_by(fn {_, value} -> value end)

        {current_pos, current_value} = data.current

        visited =
          Map.update(data.visited, current_pos, current_value, &Enum.min([&1, current_value]))

        [next_to_visit | nexts] = next_to_visit

        case next_to_visit do
          {^bottom_right_pos, value} ->
            {:halt, value}

          _ ->
            {:cont,
             %{
               current: next_to_visit,
               last: data.current,
               next_to_visit: nexts,
               visited: visited
             }}
        end
      end
    )
    |> IO.inspect()
  end

  def get_nearby_cells(grid, {{x, y}, value_from_start}, last) do
    top = {x, y - 1}
    bottom = {x, y + 1}
    left = {x - 1, y}
    right = {x + 1, y}

    adjacents = [
      {top, grid[top]},
      {bottom, grid[bottom]},
      {left, grid[left]},
      {right, grid[right]}
    ]

    adjacents
    |> Enum.reject(fn
      # not the last pos
      {^last, _} -> true
      # exclude start point
      {{0, 0}, _} -> true
      {_, value} -> is_nil(value)
    end)
    |> Enum.map(fn {pos, value} -> {pos, value + value_from_start} end)
  end
end

defmodule Day15.Part1.Parsing do
  def read_file() do
    [filename] = System.argv()

    grid_in_double_list =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    width = Enum.count(Enum.at(grid_in_double_list, 0))
    height = Enum.count(grid_in_double_list)

    {to_map(grid_in_double_list), width, height}
  end

  # return map where key is {x, y} and value is the room weight
  def to_map(file) do
    Enum.reduce(Enum.with_index(file), %{}, fn {line, y}, total ->
      elems_on_line =
        for {elem, x} <- Enum.with_index(line), into: %{} do
          {{x, y}, elem}
        end

      Map.merge(total, elems_on_line)
    end)
  end
end
