require '../utils'

$north = [0, -1]
$west = [-1, 0]
$south = [0, 1]
$east = [1, 0]

def shift_rock(map, rock, direction)
  map.set(rock[0], rock[1], ".")
  loop do
    next_x = rock[0] + direction[0]
    next_y = rock[1] + direction[1]
    next_cell = map.at(next_x, next_y)

    if next_cell == "."
      rock = [next_x, next_y]
    else
      map.set(rock[0], rock[1], "O")
      return
    end
  end
end

def compute_support_north(map)
  map.lines.reverse.each_with_index.map {|line, index|
    nb_rocks = line.count {|cell| cell == "O" }
    nb_rocks * (index + 1)
  }.sum
end

def get_all_rocks(map, direction)
  all_rocks = map.each_cell.select {|x, y| map.at(x, y) == "O"}
  all_rocks.sort_by{|x, y| (x * direction[0] * -1) + (y * direction[1] * -1)}
end

def get_size_cycle(map)
  cache = Hash.new
  start_cycle = 0
  size_cycle = 0

  (0..1000000000).each{|i|
    [$north, $west, $south, $east].each {|direction|
      get_all_rocks(map, direction).each{|rock| shift_rock(map, rock, direction)}
    }
    key = map.lines.to_s
    if cache.has_key?(key)
      if start_cycle == 0
        start_cycle = i
      end
      if cache[key] == 1
        cache[key] = 2
        size_cycle += 1
      else
        return start_cycle, size_cycle
      end
    else
      cache[key] = 1
    end
  }
end

def part_1(file)
  map = TwoDimMap.new(file.readlines)
  get_all_rocks(map, $north).each{|rock| shift_rock(map, rock, $north)}

  compute_support_north(map)
end

def part_2(file)
  original_file = file.readlines
  map = TwoDimMap.new(original_file.clone())

  # compute when the cycle starts, and how long is the cycle
  start_cycle, size_cycle = get_size_cycle(map)
  index = start_cycle + (1_000_000_000 - start_cycle) % size_cycle - 1

  # Not very optimal, but we run again the same amount of steps on a fresh map to get the results
  map = TwoDimMap.new(original_file.clone())
  (0..index).each{
    [$north, $west, $south, $east].each {|direction|
      get_all_rocks(map, direction).each{|rock| shift_rock(map, rock, direction)}
    }
  }

  compute_support_north(map)
end

puts "part 1 example = #{part_1(File.open("example.txt"))}"
puts "part 1 input = #{part_1(File.open("input.txt"))}"
puts "part 2 example = #{part_2(File.open("example.txt"))}"
puts "part 2 input = #{part_2(File.open("input.txt"))}"
