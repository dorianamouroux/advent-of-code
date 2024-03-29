require '../utils'

class Map < TwoDimMap
  def clear_all_numbers
    numbers = []

    (0..@data.length).each {|y|
      (0..@data[0].length).each {|x|
        symbol = at(x, y)
        if symbol and not symbol.match?(/[0-9\.]/)
          numbers.push(clear_numbers_around(x, y))
        end
      }
    }

    numbers.compact
  end

  def clear_numbers_around(x, y)
    removed_numbers = all_adjacent_cells(x, y).map {|x, y| clear_number(x, y)}.compact

    if at(x, y) == "*" and removed_numbers.length == 2
      removed_numbers[0] * removed_numbers[1]
    end
  end

  def clear_number(from_x, y)
    # if current symbol is not a number, we skip
    symbol = at(from_x, y)
    if not symbol or not symbol.match?(/[0-9]/)
      return
    end

    # Otherwise, replace number with "." and return it
    number = [symbol]
    @data[y][from_x] = "."

    # remove right to left
    x = from_x - 1
    loop do
      symbol = at(x, y)
      break if symbol == nil or not symbol.match?(/[0-9]/)
      number.prepend(symbol)
      @data[y][x] = "."
      x -= 1
    end

    # remove left to right
    x = from_x + 1
    loop do
      symbol = at(x, y)
      break if symbol == nil or not symbol.match?(/[0-9]/)
      number.push(symbol)
      @data[y][x] = "."
      x += 1
    end

    number.join("").to_i
  end

  def find_numbers
    @data.map{|line|
      line.join("").scan(/(\d+)/).to_a.flatten.map{|number| number.to_i}
    }.flatten
  end
end

def part_1(file)
  map = Map.new(file.readlines)

  all_numbers = map.find_numbers.sum
  map.clear_all_numbers
  not_part_numbers = map.find_numbers.sum

  all_numbers - not_part_numbers
end

def part_2(file)
  map = Map.new(file.readlines)
  map.clear_all_numbers.sum
end

puts "part 1 example = #{part_1(File.open("example.txt"))}" # 4361
puts "part 1 input = #{part_1(File.open("input.txt"))}" # 551094
puts "part 2 example = #{part_2(File.open("example.txt"))}" # 467835
puts "part 2 input = #{part_2(File.open("input.txt"))}" # 80179647
