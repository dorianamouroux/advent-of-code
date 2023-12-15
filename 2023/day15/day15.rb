def hash(to_hash)
  current_value =0
  to_hash.each{|char|
    current_value += char.ord
    current_value *= 17
    current_value = current_value % 256
  }
  current_value
end

def remove_from_box(boxes, box_name)
  box_nb = hash(box_name)
  if boxes.has_key?(box_nb)
    boxes[box_nb] = boxes[box_nb].select{|name, _| name != box_name}
  end
end

def upsert_from_box(boxes, box_name, amount)
  box_nb = hash(box_name)
  value = [box_name, amount.to_i]

  if boxes.has_key?(box_nb)
    to_update = boxes[box_nb].index{|name, _| name == box_name}
    if to_update != nil
      boxes[box_nb][to_update] = value
    else
      boxes[box_nb].append(value)
    end
  else
    boxes[box_nb] = [value]
  end
end

def part_1(file)
  file.read.strip.split(",").sum{|value| hash(value.split(""))}
end

def part_2(file)
  boxes = Hash.new

  file.read.strip.split(",").each{|value|
    instruction = value.split("")
    if instruction.include?("-")
      *box_name, _ = instruction
      remove_from_box(boxes, box_name)
    else
      *box_name, _, amount = instruction
      upsert_from_box(boxes, box_name, amount)
    end
  }

  boxes.sum{|box_nb, lenses|
    value = lenses.each_with_index.sum{|lense, in_box_index|
      _, focal_length = lense
      (box_nb + 1) * (in_box_index + 1) * focal_length
    }
  }
end

puts "part 1 example = #{part_1(File.open("example.txt"))}"
puts "part 1 input = #{part_1(File.open("input.txt"))}"
puts "part 2 example = #{part_2(File.open("example.txt"))}"
puts "part 2 input = #{part_2(File.open("input.txt"))}"
