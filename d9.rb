def diffs(numbers)
  numbers.each_cons(2).map { |a, b| b - a }
end

def predict_last(numbers)
  numbers.all?(&:zero?) ? 0 : numbers.last + predict_last(diffs(numbers))
end

def predict_first(numbers)
  numbers.all?(&:zero?) ? 0 : numbers.first - predict_first(diffs(numbers))
end

def part1(file_name)
  result = File.open(file_name, 'r').map { |line| predict_last(line.split(' ').map(&:to_i)) }.sum

  puts result
end

def part2(file_name)
  result = File.open(file_name, 'r').map { |line| predict_first(line.split(' ').map(&:to_i)) }.sum

  puts result
end

puts("== PART1 ==")
part1('test/d9.txt')
part1('input/d9.txt')

puts("== PART2 ==")
part2('test/d9.txt')
part2('input/d9.txt')
