def parse_network(nodes)
  network = Hash.new

  nodes.each{|node|
    room_name, left, right = node[0..2], node[7..9], node[12..14]
    network[room_name] = [left, right]
  }

  network
end

def get_next_room(network, instructions, i, current_room)
  current_index = i % instructions.length
  if instructions[current_index] == "L"
    return network[current_room][0]
  else
    return network[current_room][1]
  end
end

def solve(current_room, network, instructions, end_condition)
  (0..).each do |i|
    if end_condition.call(current_room)
      return i
    end
    current_room = get_next_room(network, instructions, i, current_room)
  end
end

def part_1(file)
  instructions, _, *nodes = file.readlines
  instructions = instructions.strip!.split("")
  network = parse_network(nodes)
  solve("AAA", network, instructions, lambda {|room| room == "ZZZ"})
end

def part_2(file)
  instructions, _, *nodes = file.readlines
  instructions = instructions.strip!.split("")
  network = parse_network(nodes)
  rooms = network.keys.select {|room_name| room_name.end_with?("A")}

  rooms.map {|room|
    solve(room, network, instructions, lambda {|room| room.end_with?("Z")})
  }.reduce(1, :lcm)
end

puts "part 1 example = #{part_1(File.open("example.txt"))}"
puts "part 1 example 2 = #{part_1(File.open("example_2.txt"))}"
puts "part 1 input = #{part_1(File.open("input.txt"))}"
puts "part 2 example = #{part_2(File.open("example_3.txt"))}"
puts "part 2 input = #{part_2(File.open("input.txt"))}"
