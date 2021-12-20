defmodule Packet do
  defstruct [:type, :version, :length, children: [] ]
end

defmodule Day6 do

  def main() do
    to_decrypt = Parsing.read_file_in_binary()
    to_decrypt
    |> read_all_packets
    |> IO.inspect(charlists: :as_lists)
    |> sum_versions()
    |> IO.inspect(charlists: :as_lists)
  end

  def sum_versions(%Packet{children: []} = packet), do: packet.version
  def sum_versions(%Packet{} = packet) do
    packet.children
    |> Enum.map(& sum_versions(&1))
    |> Enum.sum()
    |> Kernel.+(packet.version)
  end
  def sum_versions(_), do: 0

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
        children: [number],
        length: header_length + length,
      }
      {packet, to_decrypt}
    else
      {length_children, children_type, length_children_value, to_decrypt} = get_length_children(to_decrypt)
      {children, to_decrypt} = get_children(to_decrypt, children_type, length_children, [])
      packet = %Packet{
        version: version,
        type: type,
        children: children,
        length: header_length + sum_children_length(children) + length_children_value,
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


defmodule Parsing do
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
    "F" => "1111",
  }

  def read_file_in_binary() do
    [to_decrypt] = System.argv()
    to_decrypt
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(& Map.get(@hex_to_bin, &1))
    |> Enum.join("")
  end
end

Day6.main()
