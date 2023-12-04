def get_winning_numbers(file)
  file.readlines.map {|line|
    _, score = line.split(': ', 2)
    winning_numbers, my_numbers = score.split(' | ', 2)
    winning_numbers = winning_numbers.scan(/(\d+)/).to_a.flatten
    my_numbers = my_numbers.scan(/(\d+)/).to_a.flatten
    winning_numbers.intersection(my_numbers).length
  }
end

def part_1(file)
  get_winning_numbers(file)
    .select{|result| result > 0}
    .map {|result| 2.pow(result - 1)}
    .sum
end

def count_score(results, from, to)
  (from..to).sum{|current_index|
    value = 1
    if results[current_index] > 0
      next_from = current_index + 1
      next_to = current_index + results[current_index]
      value += count_score(results, next_from, next_to)
    end
    value
  }
end

def part_2(file)
  results = get_winning_numbers(file)
  count_score(results, 0, results.length - 1)
end

puts "part 1 example = #{part_1(File.open("example.txt"))}"
puts "part 1 input = #{part_1(File.open("input.txt"))}"
puts "part 2 example = #{part_2(File.open("example.txt"))}"
puts "part 2 input = #{part_2(File.open("input.txt"))}"
