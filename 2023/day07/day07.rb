$cards = Hash[
  "A" => 13,
  "K" => 12,
  "Q" => 11,
  "J" => 10,
  "T" => 9,
  "9" => 8,
  "8" => 7,
  "7" => 6,
  "6" => 5,
  "5" => 4,
  "4" => 3,
  "3" => 2,
  "2" => 1,
]


def compare_individual_cards(left, right, with_joker)
  left.zip(right).each {|left_card, right_card|
    value_left = (with_joker and left_card == "J") ? 0 : $cards[left_card]
    value_right = (with_joker and right_card == "J") ? 0 : $cards[right_card]
    result = value_left <=> value_right
    if result != 0
      return result
    end
  }
end

def compare_frequencies(combos_left, combos_right)
  combos_left.zip(combos_right).each{|left_combo, right_combo|
    if not left_combo
      return -1
    end
    if not right_combo
      return 1
    end
    result = left_combo <=> right_combo
    if result != 0
      return result
    end
  }
end

def frequencies(hand, with_joker)
  if with_joker
    nb_jokers = hand.count {|card| card == "J"}
    hand = hand.select {|card| card != "J"}
    groups = hand.group_by(&:itself).transform_values!(&:size).values.sort.reverse
    if groups.length > 0
      groups[0] += nb_jokers
      return groups
    else
      return [nb_jokers]
    end
  else
    return hand.group_by(&:itself).transform_values!(&:size).values.sort.reverse
  end
end

def fight_hands(left_hand, right_hand, with_joker)
  if left_hand == right_hand
    return 0
  end

  combos_left = frequencies(left_hand, with_joker)
  combos_right = frequencies(right_hand, with_joker)

  if combos_left == combos_right
    return compare_individual_cards(left_hand, right_hand, with_joker)
  end

  compare_frequencies(combos_left, combos_right)
end


def compute_score(file, with_joker)
  file.readlines.map {|hand| hand.strip!.split(" ")}.sort { |left_hand, right_hand|
    fight_hands(left_hand[0].split(""), right_hand[0].split(""), with_joker)
  }.map.with_index {|card, index|
    _, bid = card
    (index + 1) * bid.to_i
  }.sum
end

puts "part 1 example = #{compute_score(File.open("example.txt"), false)}"
puts "part 1 input = #{compute_score(File.open("input.txt"), false)}"
puts "part 2 example = #{compute_score(File.open("example.txt"), true)}"
puts "part 2 input = #{compute_score(File.open("input.txt"), true)}"
