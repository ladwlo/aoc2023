def process_patterns(file_name)
  pattern = []
  File.open(file_name, 'r').each_line(chomp: true) do |line|
    if line.empty?
      yield pattern
      pattern = []
    else
      pattern << line.chars
    end
  end
  yield pattern unless pattern.empty?
end

def line_for_horizontal_reflection(pattern, target_diff)
  (0..(pattern.size - 2)).each do |i|
    line_count = [i + 1, pattern.size - i - 1].min
    line_diff = (0...line_count).map do |j|
      pattern[i - j].zip(pattern[i + j + 1]).count { |a, b| a != b }
    end.sum.abs
    return i + 1 if line_diff == target_diff
  end

  0
end

def line_for_vertical_reflection(pattern, target_diff)
  line_for_horizontal_reflection(pattern.transpose, target_diff)
end

def solve(file_name)
  result1 = result2 = 0
  process_patterns(file_name) do |pattern|
    result1 += line_for_vertical_reflection(pattern, 0)
    result1 += 100 * line_for_horizontal_reflection(pattern, 0)
    result2 += line_for_vertical_reflection(pattern, 1)
    result2 += 100 * line_for_horizontal_reflection(pattern, 1)
  end

  puts("Part 1: #{result1}")
  puts("Part 2: #{result2}")
end

puts('== TEST ==')
solve('test/d13.txt')
puts('== INPUT ==')
solve('input/d13.txt')
