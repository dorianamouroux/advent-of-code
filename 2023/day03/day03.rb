class Map
  @@data = []
  def initialize(file)
     @data = file.readlines.map {|line| line.strip!.split("")}
  end

  def width
    @data[0].length
  end

  def height
    @data.length
  end

  def at(x, y)
    unless x < 0 or x >= width() or y < 0 or y >= height()
      @data[y][x]
    end
  end

  def clear_numbers_around(x, y)
    symbol = at(x, y)

    removed = [
      # top line
      clear_number(x - 1, y - 1),
      clear_number(x, y - 1),
      clear_number(x + 1, y - 1),

      # left and right,
      clear_number(x - 1, y),
      clear_number(x + 1, y),

      # bottom line
      clear_number(x - 1, y + 1),
      clear_number(x, y + 1),
      clear_number(x + 1, y + 1),
    ].compact

    if symbol == "*" and removed.length == 2
      removed[0] * removed[1]
    else
      0
    end
  end

  def clear_number(from_x, y)
    # if current symbol is not a number, we skip
    symbol = at(from_x, y)
    if not symbol or not symbol.match?(/[0-9]/)
      return
    end

    number = [symbol]

    # remove right to left
    x = from_x - 1
    symbol = at(x, y)
    while symbol != nil and symbol.match?(/[0-9]/)
      number.prepend(symbol)
      @data[y][x] = "."
      x -= 1
      symbol = at(x, y)
    end

    # remove left to rihht
    x = from_x + 1
    symbol = at(x, y)
    while symbol != nil and symbol.match?(/[0-9]/)
      number.push(symbol)
      @data[y][x] = "."
      x += 1
      symbol = at(x, y)
    end

    # clear current cell
    @data[y][from_x] = "."

    number.join("").to_i
  end

  def print
    @data.each{|line|
      puts line.join("").to_s
    }
  end

  def find_numbers
    @data.map{|line|
      line.join("").scan(/(\d+)/).to_a.flatten.map{|number| number.to_i}
    }.flatten
  end
end

def part_1(file)
  map = Map.new(file)

  all_numbers = map.find_numbers

  (0..map.height).each {|y|
    (0..map.width).each {|x|
      symbol = map.at(x, y)
      if symbol and not symbol.match?(/[0-9\.]/)
        map.clear_numbers_around(x, y)
      end
    }
  }

  not_part_numbers = map.find_numbers

  all_numbers.select{|number|
    if not_part_numbers.include?(number)
      not_part_numbers.delete_at(not_part_numbers.index(number))
      false
    else
      true
    end
  }.sum
end

def part_2(file)
  map = Map.new(file)
  numbers = []

  (0..map.height).each {|y|
    (0..map.width).each {|x|
      symbol = map.at(x, y)
      if symbol and not symbol.match?(/[0-9\.]/)
        numbers.push(map.clear_numbers_around(x, y))
      end
    }
  }

  numbers.sum
end

puts "part 1 example = #{part_1(File.open("example.txt"))}"
puts "part 1 input = #{part_1(File.open("input.txt"))}"
puts "part 2 example = #{part_2(File.open("example.txt"))}"
puts "part 2 input = #{part_2(File.open("input.txt"))}"
