require '../utils'

$north = [0, -1]
$west = [-1, 0]
$south = [0, 1]
$east = [1, 0]

class Cell
  @@symbol
  @@is_visited

  def initialize(symbol)
    @symbol = symbol
    @is_visited = false
  end

  def symbol
    @symbol
  end

  def set_visited
    @is_visited = true
  end

  def to_s
    @is_visited ? "#" : "."
  end
end

class Beam
  @@pos
  @@direction

  def initialize(pos, direction)
    @pos = pos
    @direction = direction
  end

  def move(map)
    next_x = @pos[0] + @direction[0]
    next_y = @pos[1] + @direction[1]
    next_cell = map.at(next_x, next_y)

    if map.at(@pos[0], @pos[1])
      map.at(@pos[0], @pos[1]).set_visited
    end

    if next_cell == nil
      return nil # out of map, bye bye
    elsif next_cell.symbol == "/" || next_cell.symbol == "\\"
      self.update_direction(next_cell.symbol)
    elsif next_cell.symbol == "-" && (@direction == $north || @direction == $south)
      return self.split_beam([next_x, next_y])
    elsif next_cell.symbol == "|" && (@direction == $east || @direction == $west)
      return self.split_beam([next_x, next_y])
    end

    @pos = [next_x, next_y]
    return self # same beam
  end

  def update_direction(symbol)
    if @direction == $west
      @direction = symbol == "/" ? $south : $north
    elsif @direction == $east
      @direction = symbol == "/" ? $north : $south
    elsif @direction == $north
      @direction = symbol == "/" ? $east : $west
    elsif @direction == $south
      @direction = symbol == "/" ? $west : $east
    end
  end

  def split_beam(next_pos)
    if @direction == $east || @direction == $west
      [Beam.new(next_pos, $north), Beam.new(next_pos, $south)]
    else
      [Beam.new(next_pos, $west), Beam.new(next_pos, $east)]
    end
  end

  def to_s
    "#{@pos.to_s} => #{@direction.to_s}"
  end
end

def count_energy(map, starting_beam)
  beams = [starting_beam]
  cache = Hash.new()

  while beams.length > 0 do
    beams = beams
      .map{|beam| beam.move(map)}
      .compact()
      .flatten()
      .select{|beam|
        key = beam.to_s
        if cache.has_key?(key)
          false # no need to keep computing that beam, we know the result
        else
          cache[key] = true
          true
        end
      }
  end

  map.to_s.split("").count {|cell| cell == "#"}
end

def part_1(file)
  map = TwoDimMap.new(file.readlines, Cell)
  count_energy(map, Beam.new([-1, 0], $east))
end

def part_2(file)
  lines = file.readlines
  map = TwoDimMap.new(lines, Cell)
  height = map.height
  width = map.width

  from_left = (0..height - 1).map{|from_y|
    local_map = TwoDimMap.new(lines, Cell)
    beam = Beam.new([-1, from_y], $east)
    count_energy(local_map, beam)
  }

  from_right = (0..height - 1).map{|from_y|
    local_map = TwoDimMap.new(lines, Cell)
    beam = Beam.new([width, from_y], $west)
    count_energy(local_map, beam)
  }

  from_top = (0..width - 1).map{|from_x|
    local_map = TwoDimMap.new(lines, Cell)
    beam = Beam.new([from_x, 0], $south)
    count_energy(local_map, beam)
  }

  from_bottom = (0..width - 1).map{|from_x|
    local_map = TwoDimMap.new(lines, Cell)
    beam = Beam.new([from_x, height], $north)
    count_energy(local_map, beam)
  }

  [from_left, from_right, from_top, from_bottom].flatten.max
end

puts "part 1 example = #{part_1(File.open("example.txt"))}"
puts "part 1 example 2 = #{part_1(File.open("example_2.txt"))}"
puts "part 1 input = #{part_1(File.open("input.txt"))}"
puts "part 2 example = #{part_2(File.open("example.txt"))}"
puts "part 2 input = #{part_2(File.open("input.txt"))}"
