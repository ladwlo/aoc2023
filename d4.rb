require 'set'

def part1(file_name)
  score = File.open(file_name, 'r').readlines(chomp: true).map do |line|
    number_lists = line.split(':').last.split('|')
    winning_numbers = number_lists[0].split(' ').map(&:to_i).to_set
    received_numbers = number_lists[1].split(' ').map(&:to_i).to_set
    1 << ((received_numbers & winning_numbers).size - 1) # card score
  end.reduce(0, &:+)

  puts score
end

def part2(file_name)
  lines = File.open(file_name, 'r').readlines(chomp: true)
  card_copies = (0..(lines.size-1)).map { |i| [i, 1] }.to_h
  lines.each_with_index.each do |line, card_index|
    number_lists = line.split(':').last.split('|')
    winning_numbers = number_lists[0].split(' ').map(&:to_i).to_set
    received_numbers = number_lists[1].split(' ').map(&:to_i).to_set
    matching_numbers_count = (received_numbers & winning_numbers).size
    next if matching_numbers_count.zero?

    copies_of_current_card = card_copies[card_index]
    (1..matching_numbers_count).each { |n| card_copies[card_index + n] += copies_of_current_card }
  end

  puts card_copies.values.reduce(0, &:+)
end

puts("== PART 1 ==")
part1('test/d4p1.txt')
part1('input/d4.txt')
puts("== PART 2 ==")
part2('test/d4p2.txt')
part2('input/d4.txt')
