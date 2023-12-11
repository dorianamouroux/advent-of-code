require 'set'
require '../utils'

$connections = Hash[
  [-1, 0] => ["-", "F", "L", "S"], # left
  [1, 0] => ["-", "J", "7", "S"], # right
  [0, -1] => ["|", "7", "F", "S"], # top
  [0, 1] => ["|", "J", "L", "S"], # bottom
]

def can_connect(map, current_pos, target_cell, modifier)
  current_symbol = map.at(current_pos[0], current_pos[1])
  target_symbol = map.at(target_cell[0], target_cell[1])
  reverse_modifier = [modifier[0] * -1, modifier[1] * -1]

  current_to_target = $connections[modifier].include?(target_symbol)
  target_to_current = $connections[reverse_modifier].include?(current_symbol)

  current_to_target and target_to_current
end

def find_next_connection(map, paths, current)
  $connections.keys.each{|modifier|
    cell = [current[0] + modifier[0], current[1] + modifier[1]]

    if can_connect(map, current, cell, modifier) and not paths.include?(cell)
      return cell
    end
  }
  return nil
end

def build_loop(map)
  paths = Set[]
  next_connection = map.find("S")
  while next_connection do
    paths.add(next_connection)
    next_connection = find_next_connection(map, paths, next_connection)
  end
  return paths
end

def part_1(file)
  map = TwoDimMap.new(file)
  paths = build_loop(map)

  (paths.length / 2).floor
end

def part_2(file)
  map = TwoDimMap.new(file)
  paths = build_loop(map)
  is_inside = false
  map.each_cell.count {|cell|
    symbol = map.at(cell[0], cell[1])
    is_in_loop = paths.include?(cell)

    if ["S", "|", "J", "L"].include?(symbol) and is_in_loop
      is_inside = !is_inside
    end

    is_inside and not is_in_loop
  }
end

puts "part 1 example = #{part_1(File.open("example.txt"))}"
puts "part 1 example 2 = #{part_1(File.open("example_2.txt"))}"
puts "part 1 input = #{part_1(File.open("input.txt"))}"
puts "part 2 example 1 = #{part_2(File.open("example_3.txt"))}"
puts "part 2 example 2 = #{part_2(File.open("example_4.txt"))}"
puts "part 2 example 3 = #{part_2(File.open("example_5.txt"))}"
puts "part 2 example 4 = #{part_2(File.open("example_6.txt"))}"
puts "part 2 input = #{part_2(File.open("input.txt"))}"
