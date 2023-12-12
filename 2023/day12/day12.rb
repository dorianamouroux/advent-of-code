# ".###.##.#..." -> 3,2,1 as string
def compute_result(line)
  line.split(".").map{|group|
    if group != ""
      group.length.to_s
    end
  }.compact.join(",")
end

# ".??..??...?##." -> [1, 2, 5, 6, 10] (index in string of the ?)
def get_position_unknowns(pattern)
  pattern.each_with_index.map{|char, index|
   if char == "?"
     index
   end
 }.compact
end

# "???.###", "1,1,3" -> 2 (only two missing)
def count_missing(pattern, result)
  nb_total = result.split(",").map{|number| number.to_i}.sum
  nb_known = pattern.count{|char| char == "#"}

  nb_total - nb_known
end

def create_attempt(pattern, positions)
  pattern.each_with_index.map{|char, index|
    should_be_block = positions.include?(index) || char == "#"
    should_be_block ? "#" : "."
  }.join("")
end

def count_arrangement(line)
  pattern, result = line.split(" ")
  pattern = pattern.split("")
  unknown_positions = get_position_unknowns(pattern)
  nb_missing = count_missing(pattern, result)

  unknown_positions.combination(nb_missing).count{|positions|
    line = create_attempt(pattern, positions)
    compute_result(line) == result
  }
end

def fold_line(line)
  pattern, result = line.split(" ")
  pattern_folded = ([pattern] * 5).join("?")
  result_folded = ([result] * 5).join(",")

  pattern_folded + " " + result_folded
end

def part_1(file)
  file.readlines.map{|line| count_arrangement(line)}.sum
end

puts "part 1 example = #{part_1(File.open("example.txt"))}"
puts "part 1 input = #{part_1(File.open("input.txt"))}"
# puts "part 2 example = #{part_2(File.open("example.txt"))}"
# puts "part 2 input = #{part_2(File.open("input.txt"))}"
