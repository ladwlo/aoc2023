HAND_ORDER = %w[11111 2111 221 311 32 41 5].each_with_index.to_h
CARD_ORDER = %w[2 3 4 5 6 7 8 9 T J Q K A].each_with_index.to_h
CARD_ORDER_PART2 = %w[J 2 3 4 5 6 7 8 9 T Q K A].each_with_index.to_h

def hand_order(hand)
  card_counts = hand.chars.group_by(&:itself).transform_values(&:count).map(&:last).sort.reverse.join
  HAND_ORDER[card_counts]
end

def compare_hands(h1, h2)
  c = hand_order(h1) <=> hand_order(h2)
  return c unless c.zero?

  5.times do |i|
    c = CARD_ORDER[h1[i]] <=> CARD_ORDER[h2[i]]
    return c unless c.zero?
  end

  0
end

def process_file(file_name, &block)
  hands = []
  File.open(file_name).each do |line|
    line.split(' ').tap { |h, b| hands << { hand: h, bid: b.to_i } }
  end
  yield hands # sort
  winnings = hands.each_with_index.map { |hand, index| hand[:bid] * (index + 1) }.reduce(:+)

  puts winnings
end

def part1(file_name)
  process_file(file_name) do |hands|
    hands.sort! { |h1, h2| compare_hands(h1[:hand], h2[:hand]) }
  end
end


def hand_order_part2(hand)
  card_counts = hand.chars.group_by(&:itself).transform_values(&:count)

  jokers = card_counts['J'] || 0
  if jokers.positive? && card_counts.size > 1
    card_counts.delete('J')
    card_counts_ordered = card_counts.map(&:last).sort.reverse
    card_counts_ordered[0] += jokers

    HAND_ORDER[card_counts_ordered.join]
  else
    # no jokers or only jokers - treat as a normal hand
    HAND_ORDER[card_counts.map(&:last).sort.reverse.join]
  end
end

def compare_hands_part2(h1, h2)
  c = hand_order_part2(h1) <=> hand_order_part2(h2)
  return c unless c.zero?

  5.times do |i|
    c = CARD_ORDER_PART2[h1[i]] <=> CARD_ORDER_PART2[h2[i]]
    return c unless c.zero?
  end

  0
end

def part2(file_name)
  process_file(file_name) do |hands|
    hands.sort! { |h1, h2| compare_hands_part2(h1[:hand], h2[:hand]) }
  end
end

puts('== PART 1 ==')
part1('test/d7.txt')
part1('input/d7.txt')

puts('== PART 2 ==')
part2('test/d7.txt')
part2('input/d7.txt')