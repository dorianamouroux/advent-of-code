require '../utils'

def get_gapped_lines(lines)
  lines.each_with_index.map {|line, index|
    if line.all?{|cell| cell == "."}
      index
    end
  }.compact
end

def nb_gap_lines_between(gap_lines, pos_a, pos_b)
  gap_lines.count {|i| i.between?(pos_a, pos_b) or i.between?(pos_b, pos_a)}
end

def count_distance(gap_columns, gap_lines, galaxy_a, galaxy_b, gap_size)
  distance_x = (galaxy_a[0] - galaxy_b[0]).abs()
  distance_y = (galaxy_a[1] - galaxy_b[1]).abs()
  expanded_lines = nb_gap_lines_between(gap_lines, galaxy_a[1], galaxy_b[1])
  expanded_columns = nb_gap_lines_between(gap_columns, galaxy_a[0], galaxy_b[0])

  distance_x + distance_y + (expanded_lines * gap_size) + (expanded_columns * gap_size)
end

def compute_all_distance(file, gap)
  map = TwoDimMap.new(file)

  gap_columns = get_gapped_lines(map.columns)
  gap_lines = get_gapped_lines(map.lines)

  map
    .each_cell
    .select {|x, y| map.at(x, y) == "#"}
    .combination(2).map{|galaxy_a, galaxy_b|
      count_distance(gap_columns, gap_lines, galaxy_a, galaxy_b, gap - 1)
    }
    .sum
end

puts "part 1 example = #{compute_all_distance(File.open("example.txt"), 2)}"
puts "part 1 input = #{compute_all_distance(File.open("input.txt"), 2)}"
puts "part 2 example = #{compute_all_distance(File.open("example.txt"), 100)}"
puts "part 2 input = #{compute_all_distance(File.open("input.txt"), 1_000_000)}"
