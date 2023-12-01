def part_1(file)
  numbers = file.readlines.map { |line|
    number = line.delete("^0-9").split("")
    "#{number.first}#{number.last}".to_i
  }

  numbers.sum
end

$text_to_digit = Hash[
  "one" => "1",
  "two" => "2",
  "three" => "3",
  "four" => "4",
  "five" => "5",
  "six" => "6",
  "seven" => "7",
  "eight" => "8",
  "nine" => "9",
]

def extract_number(line)
  numbers = []
  line.strip!.split("").each_with_index { |char, index|
    if char.match?(/[a-z]/)
      rest = line[index..-1]
      number = $text_to_digit.keys.find {|text_digit| rest.start_with?(text_digit)}
      if number
        numbers.push($text_to_digit[number])
      end
    else
      numbers.push(char)
    end
  }
  numbers
end

def part_2(file)
  numbers = file.readlines.map { |line|
    number = extract_number(line)
    "#{number.first}#{number.last}".to_i
  }

  numbers.sum
end

puts "part 1 example = #{part_1(File.open("example.txt"))}"
puts "part 1 input = #{part_1(File.open("input.txt"))}"
puts "part 2 example = #{part_2(File.open("example_2.txt"))}"
puts "part 2 input = #{part_2(File.open("input.txt"))}"
