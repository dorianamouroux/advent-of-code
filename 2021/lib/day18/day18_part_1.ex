defmodule Day18.Part1 do
  alias Day18.Part1.Parsing
  alias Day18.Part1.Operations

  def main(input) do
    {map, [first_pair | pairs]} = Parsing.read_file(input)

    pairs
    |> Enum.reduce({map, first_pair}, fn b, {map, a} -> Operations.add(map, a, b) end)
    |> tap(fn {map, root} -> IO.inspect(Operations.to_string(map, root)) end)
    |> compute_magnitude()
    |> IO.inspect()
  end

  def compute_magnitude({map, pos}) do
    %{left: left, right: right} = map[pos]
    left = if is_number(left), do: left, else: compute_magnitude({map, left})
    right = if is_number(right), do: right, else: compute_magnitude({map, right})
    3 * left + 2 * right
  end
end

defmodule Day18.Part1.Operations do
  alias Day18.Pair

  def to_string(_, entry) when is_number(entry), do: "#{entry}"

  def to_string(map, entry) do
    current_pair = map[entry]
    left = to_string(map, current_pair.left)
    right = to_string(map, current_pair.right)
    "[" <> left <> "," <> right <> "]"
  end

  def add(map, a, b) do
    new_pair = Pair.new(a, b, nil)

    map =
      map
      |> update_in([a], &Map.put(&1, :parent, new_pair.id))
      |> update_in([b], &Map.put(&1, :parent, new_pair.id))
      |> put_in([new_pair.id], new_pair)

    reduce(map, new_pair.id)
  end

  def reduce(map, root) do
    # IO.inspect(Operations.to_string(map, root), label: "REDUCE CYCLE")
    {new_map, has_exploded} = explode(map, root, 1)

    if has_exploded do
      # if we could explode a number, we keep trying to explode
      reduce(new_map, root)
    else
      # try a split
      {new_map, has_split} = split(map, root)

      if has_split do
        # if we found a split, we have to start over with the explodes
        reduce(new_map, root)
      else
        # finish all operations
        {new_map, root}
      end
    end
  end

  def split(map, pos) when is_number(pos), do: {map, false}

  def split(map, pos) do
    current_pair = map[pos]

    if Pair.should_split?(current_pair.left) do
      {do_split(map, current_pair, :left), true}
    else
      {new_map, has_split} = split(map, current_pair.left)

      if has_split do
        {new_map, has_split}
      else
        if Pair.should_split?(current_pair.right) do
          {do_split(map, current_pair, :right), true}
        else
          split(map, current_pair.right)
        end
      end
    end
  end

  def do_split(map, current, side) do
    left = floor(current[side] / 2)
    right = ceil(current[side] / 2)
    new_pair = Pair.new(left, right, current.id)

    map
    |> Map.put(new_pair.id, new_pair)
    |> put_in([current.id, side], new_pair.id)
  end

  def explode(map, pos, _) when is_number(pos), do: {map, false}

  def explode(map, pos, depth) do
    current_pair = map[pos]

    if Pair.number_pair?(current_pair) do
      if depth > 4 do
        {do_explode(map, current_pair), true}
      else
        {map, false}
      end
    else
      {new_map, has_exploded} = explode(map, current_pair.left, depth + 1)

      if has_exploded do
        {new_map, has_exploded}
      else
        explode(map, current_pair.right, depth + 1)
      end
    end
  end

  def do_explode(map, current_pair) do
    left = find_pair_on_left(map, current_pair)
    right = find_pair_on_right(map, current_pair)

    # increment the number of the left
    map =
      if left != nil do
        update_in(map, [left.id], fn
          %{right: right} = pair when is_number(right) ->
            Map.put(pair, :right, right + current_pair.left)

          pair ->
            Map.put(pair, :left, pair.left + current_pair.left)
        end)
      else
        map
      end

    # increment the number of the right
    map =
      if right != nil do
        update_in(map, [right.id], fn
          %{left: left} = pair when is_number(left) ->
            Map.put(pair, :left, left + current_pair.right)

          pair ->
            Map.put(pair, :right, pair.right + current_pair.right)
        end)
      else
        map
      end

    # replace current pair with 0
    current_id = current_pair.id

    map =
      case Map.get(map, current_pair.parent) do
        %{left: ^current_id, id: id} -> put_in(map, [id, :left], 0)
        %{right: ^current_id, id: id} -> put_in(map, [id, :right], 0)
      end

    # delete current pair
    Map.delete(map, current_pair.id)
  end

  def find_pair_on_left(map, origin) do
    parent = Map.get(map, origin.parent)

    cond do
      parent == nil -> nil
      parent.left == origin.id -> find_pair_on_left(map, parent)
      parent.right == origin.id -> find_pair_with_right_is_number(map, parent, nil)
    end
  end

  def find_pair_with_right_is_number(map, parent, nil) do
    if is_number(parent.left) do
      parent
    else
      find_pair_with_right_is_number(map, parent, Map.get(map, parent.left))
    end
  end

  def find_pair_with_right_is_number(map, parent, pair) do
    if is_number(pair.right) do
      pair
    else
      find_pair_with_right_is_number(map, parent, Map.get(map, pair.right))
    end
  end

  def find_pair_on_right(map, origin) do
    parent = Map.get(map, origin.parent)

    cond do
      parent == nil -> nil
      parent.right == origin.id -> find_pair_on_right(map, parent)
      parent.left == origin.id -> find_pair_with_left_is_number(map, parent, nil)
    end
  end

  def find_pair_with_left_is_number(map, parent, nil) do
    if is_number(parent.right) do
      parent
    else
      find_pair_with_left_is_number(map, parent, Map.get(map, parent.right))
    end
  end

  def find_pair_with_left_is_number(map, parent, pair) do
    if is_number(pair.left) do
      pair
    else
      find_pair_with_left_is_number(map, parent, Map.get(map, pair.left))
    end
  end
end

defmodule Day18.Part1.Parsing do
  alias Day18.Pair

  def read_file(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, []}, fn line, {map, pairs} ->
      {root, _, new_map} = string_to_pair(line, nil, map)
      {new_map, pairs ++ [root]}
    end)
  end

  def string_to_pair("[" <> line, parent \\ nil, current \\ %{}) do
    pair = Pair.new(nil, nil, parent)
    {left, line, current} = get_next_element(line, pair.id, current)
    "," <> line = line
    {right, line, current} = get_next_element(line, pair.id, current)
    "]" <> line = line
    pair = pair |> Map.put(:left, left) |> Map.put(:right, right)
    current = Map.put(current, pair.id, pair)
    {pair.id, line, current}
  end

  defp get_next_element(line, parent, current) do
    if String.at(line, 0) == "[" do
      string_to_pair(line, parent, current)
    else
      {number, rest} = Integer.parse(line)
      {number, rest, current}
    end
  end
end
