require '../utils'

def check_mirror(line, index)
  left_split = line[0..(index - 1)].reverse
  right_split = line[index..-1]

  left_split.zip(right_split).each {|left, right|
    # we reach either end
    if left == nil || right == nil
      return true
    end
    # not mirror
    if left != right
      return false
    end
  }
  # both splits are equal
  return true
end

def get_reflection(lines, to_exclude)
  all_reflections = lines.each_with_index.map { |line, index|
    (1..line.length - 1).map{|cell_index|
      if to_exclude != cell_index && check_mirror(line, cell_index)
        cell_index
      end
    }.compact
  }.reduce(:&).first || 0
end

def flip_all_smudges(file)
  return to_enum(__method__, file) unless block_given?

  file.split("").each_with_index { |char, index|
    if char != "\n"
      new_file = file.clone()
      new_file[index] = char == "#" ? "." : "#"
      yield new_file
    end
  }
end

def part_1(file)
  nb_columns = 0
  nb_lines = 0
  file.read.split("\n\n").each{|terrain|
    map = TwoDimMap.new(terrain.split("\n"))
    nb_columns += get_reflection(map.lines, 0)
    nb_lines += get_reflection(map.columns, 0)
  }
  nb_columns + (nb_lines * 100)
end

def get_reflection_with_smudge(terrain)
  map = TwoDimMap.new(terrain.split("\n"))
  reflection_lines = get_reflection(map.lines, 0)
  reflection_columns = get_reflection(map.columns, 0)

  terrain.split("").each_with_index do |char, index|
    if char != "\n"
      flipped_terrain = terrain.clone()
      flipped_terrain[index] = char == "#" ? "." : "#"
      flipped_map = TwoDimMap.new(flipped_terrain.split("\n"))
      new_reflection_lines = get_reflection(flipped_map.lines, reflection_lines)
      new_reflection_columns = get_reflection(flipped_map.columns, reflection_columns)

      if [new_reflection_lines, new_reflection_columns].compact.sum > 0
        return [new_reflection_lines, new_reflection_columns]
      end
    end
  end
end

def part_2(file)
  nb_columns = 0
  nb_lines = 0
  file.read.split("\n\n").each{|terrain|
    reflection_lines, reflection_columns = get_reflection_with_smudge(terrain)
    nb_columns += reflection_lines
    nb_lines += reflection_columns
  }
  nb_columns + (nb_lines * 100)
end

puts "part 1 example = #{part_1(File.open("example.txt"))}"
puts "part 1 input = #{part_1(File.open("input.txt"))}"
puts "part 2 example = #{part_2(File.open("example.txt"))}"
puts "part 2 example = #{part_2(File.open("example_2.txt"))}"
puts "part 2 input = #{part_2(File.open("input.txt"))}"
