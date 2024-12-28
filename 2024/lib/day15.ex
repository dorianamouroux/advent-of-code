defmodule Aoc.Day15 do
  @day "15"
  @modifier %{
    "<" => {-1, 0},
    ">" => {1, 0},
    "^" => {0, -1},
    "v" => {0, 1},
  }

  def part_1(path) do
    {map, instructions} = parse(path)

    {robot, _} = map
    |> Aoc.Map.all_cells()
    |> Enum.find(fn {_, value} -> value == "@" end)

    instructions
    |> Enum.reduce({map, robot}, &move_robot/2)
    |> compute_score()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    {map, instructions} = parse(path)

    map = double_map(map)

    {robot, _} = map
    |> Aoc.Map.all_cells()
    |> Enum.find(fn {_, value} -> value == "@" end)

    instructions
    |> Enum.reduce({map, robot}, &move_robot/2)
    |> compute_score()
    |> IO.inspect(label: path)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt")
    part_1("inputs/day#{@day}_input.txt")

    IO.inspect("part 2")
    part_2("inputs/day#{@day}_example.txt")
    part_2("inputs/day#{@day}_input.txt")
  end

  def parse(path) do
    [map, instructions] = Aoc.Parser.two_chunks(path)

    map = map
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Aoc.Map.new()

    instructions = instructions
    |> String.replace("\n", "")
    |> String.trim()
    |> String.split("", trim: true)

    {map, instructions}
  end

  def move_robot(instruction, {map, robot}) do
    direction = Map.get(@modifier, instruction)
    next_cell = Aoc.Map.apply_modifier(robot, direction)

    case Aoc.Map.at(map, next_cell) do
      "." ->
        map = map
        |> Aoc.Map.put(next_cell, "@")
        |> Aoc.Map.put(robot, ".")

        {map, next_cell}
      "O" ->
        empty_space = find_empty_space(map, next_cell, direction)
        if empty_space do
          map = map
          |> Aoc.Map.put(empty_space, "O")
          |> Aoc.Map.put(next_cell, "@")
          |> Aoc.Map.put(robot, ".")

          {map, next_cell}
        else
          {map, robot}
        end
      "#" ->
        {map, robot}
      _half_box ->
        box = get_full_box(map, next_cell)
        boxes_to_move = get_boxes_to_move(map, box, direction)

        if boxes_to_move do

          # IO.inspect boxes_to_move, label: "boxes_to_move"

          map = map
          |> move_all_boxes(boxes_to_move, direction)
          |> Aoc.Map.put(next_cell, "@")
          |> Aoc.Map.put(robot, ".")

          {map, next_cell}
        else
          {map, robot}
        end
    end
  end

  def find_empty_space(map, next_cell, direction) do
    case Aoc.Map.at(map, next_cell) do
      "." -> next_cell
      "#" -> nil
      "O" ->
        next_cell = Aoc.Map.apply_modifier(next_cell, direction)
        find_empty_space(map, next_cell, direction)
    end
  end

  def double_map(map) do
    map
    |> Aoc.Map.all_cells()
    |> Enum.map(fn {{x, y}, value} ->
      new_x = (x * 2)
      old_cell = case value do
        "O" -> {{new_x, y}, "["}
        cell -> {{new_x, y}, cell}
      end

      new_cell = case value do
        "." -> {{new_x + 1, y}, "."}
        "#" -> {{new_x + 1, y}, "#"}
        "@" -> {{new_x + 1, y}, "."}
        "O" -> {{new_x + 1, y}, "]"}
      end
      [old_cell, new_cell]
    end)
    |> List.flatten()
    |> Map.new()
    |> Aoc.Map.new()
  end

  def compute_score({map, _}) do
    map
    |> Aoc.Map.all_cells()
    |> Enum.map(fn {{x, y}, value} ->
      if value == "O" || value == "[" do
        x + (y * 100)
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def get_full_box(map, {x, y} = cell) do
    case Aoc.Map.at(map, cell) do
      "[" -> [{x + 1, y}, cell]
      "]" -> [{x - 1, y}, cell]
      _ -> [{x, y}]
    end
  end

  def get_boxes_to_move(map, boxes, modifier) do
    impacted_boxes = Enum.map(boxes, & Aoc.Map.apply_modifier(&1, modifier))
    impacted_boxes = impacted_boxes -- boxes
    impacted_boxes = impacted_boxes |> Enum.map(&get_full_box(map, &1)) |> List.flatten()
    impacted_boxes = Enum.reject(impacted_boxes, fn pos ->
      Aoc.Map.at(map, pos) == "."
    end)

    all_empty = Enum.empty?(impacted_boxes)

    has_wall = Enum.any?(impacted_boxes, fn pos ->
      Aoc.Map.at(map, pos) == "#"
    end)

    cond do
      all_empty -> boxes
      has_wall -> false
      true ->
        case get_boxes_to_move(map, impacted_boxes, modifier) do
          false -> false
          to_move_boxes -> to_move_boxes ++ boxes
        end
    end
  end

  def move_all_boxes(map, boxes_to_move, direction) do
    # first we remove all boxes we need to move
    clean_map = Enum.reduce(boxes_to_move, map, fn box, clean_map ->
      Aoc.Map.put(clean_map, box, ".")
    end)

    # then we put them back in the new location
    Enum.reduce(boxes_to_move, clean_map, fn box, new_map ->
      original_cell = Aoc.Map.at(map, box)
      new_pos = Aoc.Map.apply_modifier(box, direction)
      Aoc.Map.put(new_map, new_pos, original_cell)
    end)
  end
end
