defmodule Aoc.Day08 do
  @day "08"

  def part_1(path, amount_of_pairs) do
    boxes = get_boxes(path)
    circuits = Enum.map(boxes, fn box -> MapSet.new([box]) end)

    boxes
    |> compute_distances()
    |> Enum.take(amount_of_pairs)
    |> Enum.reduce(circuits, fn {{a, b}, _}, circuits -> place_in_circuit(a, b, circuits) end)
    |> Enum.map(fn circuit -> MapSet.size(circuit) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
    |> IO.inspect(label: path, limit: :infinity)
  end

  def part_2(path) do
    boxes = get_boxes(path)
    circuits = Enum.map(boxes, fn box -> MapSet.new([box]) end)

    boxes
    |> compute_distances()
    |> Enum.reduce_while(circuits, fn {{a, b}, _}, circuits ->
      case place_in_circuit(a, b, circuits) do
        # only one circuit, we found the solution
        [_] ->
          {x1, _, _} = a
          {x2, _, _} = b
          {:halt, x1 * x2}

        new_circuits ->
          {:cont, new_circuits}
      end
    end)
    |> IO.inspect(label: path, limit: :infinity)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt", 10)
    part_1("inputs/day#{@day}_input.txt", 1000)

    IO.inspect("part 2")
    part_2("inputs/day#{@day}_example.txt")
    part_2("inputs/day#{@day}_input.txt")
  end

  defp get_boxes(path) do
    path
    |> Aoc.Parser.lines()
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp place_in_circuit(a, b, circuits) do
    circuit_a_index = Enum.find_index(circuits, fn circuit -> Enum.member?(circuit, a) end)
    circuit_b_index = Enum.find_index(circuits, fn circuit -> Enum.member?(circuit, b) end)

    if circuit_a_index != circuit_b_index do
      new_circuit =
        MapSet.union(Enum.at(circuits, circuit_a_index), Enum.at(circuits, circuit_b_index))

      [a, b] = [circuit_a_index, circuit_b_index] |> Enum.sort()
      circuits = List.delete_at(circuits, b)
      circuits = List.delete_at(circuits, a)
      circuits ++ [new_circuit]
    else
      circuits
    end
  end

  defp distance({x1, y1, z1}, {x2, y2, z2}) do
    dx = x1 - x2
    dy = y1 - y2
    dz = z1 - z2
    :math.sqrt(dx * dx + dy * dy + dz * dz)
  end

  defp compute_distances(boxes, results \\ [])

  defp compute_distances([_], results) do
    Enum.sort_by(results, fn {{_, _}, distance} -> distance end)
  end

  defp compute_distances([current | rest], results) do
    distances = Enum.map(rest, fn box -> {{current, box}, distance(current, box)} end)
    compute_distances(rest, results ++ distances)
  end
end
