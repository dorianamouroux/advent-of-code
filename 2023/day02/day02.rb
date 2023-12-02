def get_nb_cubes_for_color(line, color)
  line.scan(/(\d+) #{color}/).to_a.flatten.map {|nb| nb.to_i}
end

def is_game_possible(line)
  [
    get_nb_cubes_for_color(line, "red").all? { |nb| nb <= 12},
    get_nb_cubes_for_color(line, "green").all? { |nb| nb <= 13},
    get_nb_cubes_for_color(line, "blue").all? { |nb| nb <= 14}
  ].all?
end

def part_1(file)
  file.readlines.filter_map { |line|
    game_id = line.match(/Game (\d+)/).to_a[1].to_i
    if is_game_possible(line)
      game_id
    end
  }.sum
end

def part_2(file)
  file.readlines.filter_map { |line|
    min_red = get_nb_cubes_for_color(line, "red").max
    min_green = get_nb_cubes_for_color(line, "green").max
    min_blue = get_nb_cubes_for_color(line, "blue").max

    min_red * min_green * min_blue
  }.sum
end

puts "part 1 example = #{part_1(File.open("example.txt"))}"
puts "part 1 input = #{part_1(File.open("input.txt"))}"
puts "part 2 example = #{part_2(File.open("example.txt"))}"
puts "part 2 input = #{part_2(File.open("input.txt"))}"
