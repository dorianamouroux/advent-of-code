defmodule Position do
  defstruct [:x, :y, :z, :scanner]

  def new({x, y, z}, scanner \\ nil) do
    %__MODULE__{
      x: x,
      y: y,
      z: z,
      scanner: scanner
    }
  end

  def distance_with(a, b) do
    [
      Integer.pow(b.x - a.x, 2),
      Integer.pow(b.y - a.y, 2),
      Integer.pow(b.z - a.z, 2)
    ]
    |> Enum.sum()
  end

  def with_offset(pos, 0), do: new({pos.x, pos.y, pos.z}, pos.scanner)
  def with_offset(pos, 1), do: new({pos.x, pos.z, pos.y}, pos.scanner)
  def with_offset(pos, 2), do: new({pos.z, pos.y, pos.x}, pos.scanner)
  def with_offset(pos, 3), do: new({pos.z, pos.x, pos.y}, pos.scanner)
  def with_offset(pos, 4), do: new({pos.y, pos.z, pos.x}, pos.scanner)
  def with_offset(pos, 5), do: new({pos.y, pos.x, pos.z}, pos.scanner)
end

defmodule Day19.Part1 do
  alias Day19.Part1.Parsing

  def main(input) do
    scanners =
      Parsing.parse(input)
      |> IO.inspect()

    nb_scanners = Enum.count(Map.keys(scanners))
    scanners_pos = for {id_scanner, _} <- scanners, into: %{}, do: {id_scanner, %{}}
    {_, beacons} = try_with_pos(scanners, 0, scanners_pos, nb_scanners)

    beacons
    |> Enum.count()
    |> IO.inspect()
  end

  def get_completed_scanner(scanners) do
    nb_scanners = map_size(scanners)

    Enum.find(scanners, fn {_, beacons} ->
      beacons_from =
        beacons
        |> Enum.map(& &1.scanner)
        |> MapSet.new()
        |> MapSet.size()

      beacons_from == nb_scanners
    end)
  end

  def try_with_pos(scanners, index, scanners_pos, nb_scanners) when index >= nb_scanners do
    try_with_pos(scanners, 0, scanners_pos, nb_scanners)
  end

  def try_with_pos(scanners, index, scanners_pos, nb_scanners) do
    # IO.inspect("Try with #{index}")
    IO.inspect(scanners_pos)
    {scanners, scanners_pos} = resolve(scanners, index, scanners_pos)
    computed_scanner = get_completed_scanner(scanners)

    if computed_scanner do
      computed_scanner
    else
      try_with_pos(scanners, index + 1, scanners_pos, nb_scanners)
    end
  end

  def resolve(scanners, index_to_try, scanners_pos) do
    IO.inspect({scanners, scanners_pos})

    scanners
    |> Map.keys()
    |> Enum.reduce({scanners, scanners_pos}, fn
      # skip current index
      ^index_to_try, total ->
        total

      scanner_id, {scanners, scanners_pos} ->
        all_beacons = scanners[index_to_try]
        beacons_in_scanner = scanners[scanner_id]
        in_common = Space.get_beacons_in_common(scanners, index_to_try, scanner_id)
        multiplier = Space.get_multiplier(in_common)

        case multiplier do
          nil ->
            {scanners, scanners_pos}

          multiplier ->
            scanner_pos = Space.get_position_scanner(in_common, multiplier)
            IO.inspect(scanner_pos, label: "position scanner #{scanner_id}:")

            all_beacons =
              in_common
              |> Space.get_beacons_not_in_common(beacons_in_scanner)
              |> Enum.map(fn pos ->
                pos = Position.with_offset(pos, multiplier.offset)

                Position.new(
                  {
                    multiplier.x * (pos.x + scanner_pos.x * multiplier.x),
                    multiplier.y * (pos.y + scanner_pos.y * multiplier.y),
                    multiplier.z * (pos.z + scanner_pos.z * multiplier.z)
                  },
                  pos.scanner
                )
              end)
              |> Enum.sort_by(fn pos -> pos.x end)
              |> Kernel.++(all_beacons)

            {
              Map.put(scanners, index_to_try, all_beacons),
              put_in(scanners_pos, [index_to_try, scanner_id], scanner_pos)
            }
        end
    end)
  end
end

defmodule Space do
  # I wish I was smart enough to generate that with code
  @multipliers for(
                 offset <- 0..5,
                 do: [
                   %{x: 1, y: 1, z: 1, offset: offset},
                   %{x: 1, y: 1, z: -1, offset: offset},
                   %{x: 1, y: -1, z: 1, offset: offset},
                   %{x: 1, y: -1, z: -1, offset: offset},
                   %{x: -1, y: 1, z: 1, offset: offset},
                   %{x: -1, y: 1, z: -1, offset: offset},
                   %{x: -1, y: -1, z: 1, offset: offset},
                   %{x: -1, y: -1, z: -1, offset: offset}
                 ]
               )
               |> List.flatten()

  def get_beacons_in_common(scanners, left, right) do
    left_scanners = Enum.filter(scanners[left], &(&1.scanner == left))
    right_scanners = Enum.filter(scanners[right], &(&1.scanner == right))

    for beacon <- left_scanners do
      distance_with_other_beacons = Space.compute_distances(beacon, left_scanners)

      for beacon_in_scanner <- right_scanners do
        distances = Space.compute_distances(beacon_in_scanner, right_scanners)

        if Space.nb_in_common(distance_with_other_beacons, distances) == 11 do
          {beacon, beacon_in_scanner}
        end
      end
      |> Enum.reject(&is_nil/1)
    end
    |> Enum.reject(&Enum.empty?/1)
    |> List.flatten()
  end

  def get_beacons_not_in_common(in_common, beacons_in_scanner) do
    in_common = Enum.map(in_common, fn {_left, right} -> right end)
    Enum.reject(beacons_in_scanner, &Enum.member?(in_common, &1))
  end

  def get_multiplier([]), do: nil

  def get_multiplier(in_common) do
    Enum.find(@multipliers, fn multiplier ->
      [first | rest] =
        Enum.map(in_common, fn {left, right} ->
          right = Position.with_offset(right, multiplier.offset)

          Position.new({
            left.x - multiplier.x * right.x,
            left.y - multiplier.y * right.y,
            left.z - multiplier.z * right.z
          })
        end)

      # are all results same
      Enum.all?(rest, &(&1 == first))
    end)
  end

  def get_position_scanner(in_common, multiplier) do
    [{left, right} | _] = in_common
    right = Position.with_offset(right, multiplier.offset)

    Position.new({
      left.x - multiplier.x * right.x,
      left.y - multiplier.y * right.y,
      left.z - multiplier.z * right.z
    })
  end

  def compute_distances(point, points) do
    points
    |> Enum.map(&Position.distance_with(point, &1))
    |> Enum.reject(&(&1 == 0))
    |> Enum.sort()
  end

  def nb_in_common(distance_a, distance_b) do
    MapSet.new(distance_a)
    |> MapSet.intersection(MapSet.new(distance_b))
    |> MapSet.size()
  end
end

defmodule Day19.Part1.Parsing do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> chunk_by_scanner(%{})
  end

  def chunk_by_scanner(["--- scanner " <> scanner | rest], all) do
    {number, _} = Integer.parse(scanner)
    next_chunk = Enum.find_index(rest, &String.starts_with?(&1, "--- scanner "))

    case next_chunk do
      nil ->
        Map.put(all, number, parse_coords(rest, number))

      index ->
        {coords_in_chunk, rest} = Enum.split(rest, index)
        all = Map.put(all, number, parse_coords(coords_in_chunk, number))
        chunk_by_scanner(rest, all)
    end
  end

  def parse_coords(coords, scanner) do
    coords
    |> Enum.map(fn coord ->
      coord
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
      |> Position.new(scanner)
    end)
  end
end
