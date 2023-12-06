def nb_victory(round)
  time, distance = round
  found_winning = false

  (0..time).count {|i|
    distance_with_time = (time - i) * i
    distance_with_time > distance
  }
end

def part_1(file)
  times, distances = file.readlines
  times = times.scan(/(\d+)/).flatten.compact.map{|n| n.to_i}
  distances = distances.scan(/(\d+)/).flatten.compact.map{|n| n.to_i}

  times.zip(distances).map{|round| nb_victory(round)}.inject(:*)
end

def part_2(file) # take 1~2 seconds but I'm happy with it
  time, distance = file.readlines
  time = time.scan(/(\d+)/).flatten.compact.join("").to_i
  distance = distance.scan(/(\d+)/).flatten.compact.join("").to_i
  nb_victory([time, distance])
end

puts "part 1 example = #{part_1(File.open("example.txt"))}"
puts "part 1 input = #{part_1(File.open("input.txt"))}"
puts "part 2 example = #{part_2(File.open("example.txt"))}"
puts "part 2 input = #{part_2(File.open("input.txt"))}"
