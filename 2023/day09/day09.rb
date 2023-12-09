def build_all_suites(number_suite)
  list_suite = [number_suite]
  while list_suite.last.any?{|nb| nb != 0}
    new_suite = list_suite.last.each_cons(2).map {|a, b| (b - a)}
    list_suite.push(new_suite)
  end
  list_suite
end

def compute_next_elem(number_suite)
  previous_number = 0
  all_suites = build_all_suites(number_suite)
  all_suites.reverse.each {|suite|
    suite.push(suite.last + previous_number)
    previous_number = suite.last
  }
  all_suites.first.last
end

def compute_prev_elem(number_suite)
  previous_number = 0
  all_suites = build_all_suites(number_suite)
  all_suites.reverse.each {|suite|
    suite.unshift(suite.first - previous_number)
    previous_number = suite.first
  }
  all_suites.first.first
end

def part_1(file)
  file.readlines.map{|line|
    number_suite = line.strip!.split(" ").map(&:to_i)
    compute_next_elem(number_suite)
  }.sum
end

def part_2(file)
  file.readlines.map{|line|
    number_suite = line.strip!.split(" ").map(&:to_i)
    compute_prev_elem(number_suite)
  }.sum
end

puts "part 1 example = #{part_1(File.open("example.txt"))}"
puts "part 1 input = #{part_1(File.open("input.txt"))}"
puts "part 2 example = #{part_2(File.open("example.txt"))}"
puts "part 2 input = #{part_2(File.open("input.txt"))}"
