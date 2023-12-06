require 'parallel'

def apply_converter(seed, converter)
  converter.each {|range|
    dest_range, source_range, range_length = range

    if seed >= source_range and seed <= source_range + range_length
      return (seed - source_range) + dest_range
    end
  }
  return seed
end

def compute_location(seed, converters)
  converters.each {|converter|
    seed = apply_converter(seed, converter)
  }
  seed
end

def part_1(file)
  seeds, *converters = file.read.split("\n\n")
  seeds = seeds.scan(/(\d+)/).to_a.flatten.map{|v| v.to_i}
  converters = converters.map{|converter|
    _, *ranges = converter.split("\n")
    ranges.map{|range|
      range.scan(/(\d+)/).to_a.flatten.map{|v| v.to_i}
    }
  }

  seeds.map{|seed| compute_location(seed, converters)}.min
end

def part_2(file)
  seeds, *converters = file.read.split("\n\n")
  seeds = seeds.scan(/(\d+)/).to_a.flatten.map{|v| v.to_i}
  converters = converters.map{|converter|
    _, *ranges = converter.split("\n")
    ranges.map{|range|
      range.scan(/(\d+)/).to_a.flatten.map{|v| v.to_i}
    }
  }

  # shameful brute-force
  results = Parallel.map(seeds.each_slice(2)) do |starting_number, range_length|
    range = starting_number..(starting_number + range_length - 1)
    seed = range.min_by{|seed| compute_location(seed, converters)}
    compute_location(seed, converters)
  end

  results.min - 1 # ¯\_(ツ)_/¯
end

puts "part 1 example = #{part_1(File.open("example.txt"))}"
puts "part 1 input = #{part_1(File.open("input.txt"))}"
puts "part 2 example = #{part_2(File.open("example.txt"))}"
puts "part 2 input = #{part_2(File.open("input.txt"))}"
