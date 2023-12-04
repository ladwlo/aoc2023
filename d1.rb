DIGITS = %w[0 1 2 3 4 5 6 7 8 9].freeze
WORDS = %w[zero one two three four five six seven eight nine].freeze

def sum(file_name, part2)
  sum = 0
  File.open(file_name, 'r').readlines.each do |line|
    d1 = d2 = nil
    (0..line.length - 1).each do |i|
      match = DIGITS.select { |d| d == line[i] }.map(&:to_i).first
      if part2
        match ||= WORDS.each_with_index.select { |w, _| w == line[i..(i + w.length - 1)] }.map(&:last).first
      end
      next unless match

      d1 ||= match
      d2 = match
    end
    sum += 10 * d1 + d2
  end
  sum
end

puts '== PART 1 =='
puts sum('test/d1p1.txt', false)
puts sum('input/d1.txt', false)
puts '== PART 2 =='
puts sum('test/d1p2.txt', true)
puts sum('input/d1.txt', true)
