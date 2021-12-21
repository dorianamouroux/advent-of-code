defmodule Day16.Part2.Packet do
  defstruct [:type, :version, :length, children: [], value: 0]
end

defmodule Day16.Part2 do
  alias Day16.Part2.Packet

  def main(input) do
    to_decrypt = Day16.Part2.Parsing.read_file_in_binary(input)

    to_decrypt
    |> read_all_packets
    |> IO.inspect(charlists: :as_lists)
    |> resolve_value()
    |> IO.inspect(charlists: :as_lists)
  end

  def compute(%Packet{type: 0, children: children}), do: Enum.sum(children)
  def compute(%Packet{type: 1, children: children}), do: Enum.product(children)
  def compute(%Packet{type: 2, children: children}), do: Enum.min(children)
  def compute(%Packet{type: 3, children: children}), do: Enum.max(children)
  def compute(%Packet{type: 4, value: value}), do: value
  def compute(%Packet{type: 5, children: [first, second]}), do: if(first < second, do: 1, else: 0)
  def compute(%Packet{type: 6, children: [first, second]}), do: if(first > second, do: 1, else: 0)

  def compute(%Packet{type: 7, children: [first, second]}),
    do: if(first == second, do: 1, else: 0)

  def resolve_value(packet) do
    resolved_children =
      Enum.map(packet.children, fn
        %Packet{} = packet -> resolve_value(packet)
        number -> number
      end)

    compute(Map.put(packet, :children, resolved_children))
  end

  def read_all_packets(to_decrypt) do
    to_decrypt
    |> read_next_packet()
    |> elem(0)
  end

  def read_next_packet(to_decrypt) do
    header_length = 6
    {version, to_decrypt} = String.split_at(to_decrypt, 3)
    version = String.to_integer(version, 2)
    {type, to_decrypt} = String.split_at(to_decrypt, 3)
    type = String.to_integer(type, 2)

    if type == 4 do
      {number, length, to_decrypt} = read_number(to_decrypt)

      packet = %Packet{
        version: version,
        type: type,
        value: number,
        length: header_length + length
      }

      {packet, to_decrypt}
    else
      {length_children, children_type, length_children_value, to_decrypt} =
        get_length_children(to_decrypt)

      {children, to_decrypt} = get_children(to_decrypt, children_type, length_children, [])

      packet = %Packet{
        version: version,
        type: type,
        children: children,
        length: header_length + sum_children_length(children) + length_children_value
      }

      {packet, to_decrypt}
    end
  end

  def sum_children_length(children) do
    children
    |> Enum.map(& &1.length)
    |> Enum.sum()
  end

  def get_children(to_decrypt, _, 0, children), do: {children, to_decrypt}

  def get_children(to_decrypt, children_type, length, children) do
    {next_children, to_decrypt} = read_next_packet(to_decrypt)
    children = [next_children | children]
    length = if(children_type == "1", do: length - 1, else: length - next_children.length)
    get_children(to_decrypt, children_type, length, children)
  end

  def get_length_children(to_decrypt) do
    {children_type, to_decrypt} = String.split_at(to_decrypt, 1)
    nb_next_bits = if(children_type == "1", do: 11, else: 15)
    {size, to_decrypt} = String.split_at(to_decrypt, nb_next_bits)
    {String.to_integer(size, 2), children_type, nb_next_bits + 1, to_decrypt}
  end

  def read_number(packet, number \\ "", length \\ 0) do
    {next_number, packet} = String.split_at(packet, 5)
    {prefix, number_part} = String.split_at(next_number, 1)
    number = number <> number_part
    length = length + 5

    if prefix == "1" do
      read_number(packet, number, length)
    else
      {String.to_integer(number, 2), length, packet}
    end
  end
end

defmodule Day16.Part2.Parsing do
  @hex_to_bin %{
    "0" => "0000",
    "1" => "0001",
    "2" => "0010",
    "3" => "0011",
    "4" => "0100",
    "5" => "0101",
    "6" => "0110",
    "7" => "0111",
    "8" => "1000",
    "9" => "1001",
    "A" => "1010",
    "B" => "1011",
    "C" => "1100",
    "D" => "1101",
    "E" => "1110",
    "F" => "1111"
  }

  def read_file_in_binary(input) do
    input
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(&Map.get(@hex_to_bin, &1))
    |> Enum.join("")
  end
end
