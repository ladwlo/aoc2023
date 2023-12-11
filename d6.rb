def part1(file_name)
  f = File.open(file_name, 'r')
  times = f.readline.split(':').last.split(' ').map(&:to_i)
  distances = f.readline.split(':').last.split(' ').map(&:to_i)

  result = times.zip(distances).map do |time, distance|
    (1..(time - 1)).map { |t| (time - t) * t }.select { |d| d > distance }.count
  end.reduce(1, &:*)

  puts result
ensure
  f.close
end

def part2(file_name)
  f = File.open(file_name, 'r')
  time = f.readline.split(':').last.gsub(' ', '').to_i
  distance = f.readline.split(':').last.gsub(' ', '').to_i

  # from 1st derivative of distance function: dist(t) = (time - t) * t
  # dist'(t) = time - 2 * t
  # dist'(t) = 0 => t = time / 2
  peak_t = time / 2

  # for odd time, both peak_t and (peak_t + 1) correspond to the max distance
  # for even time, max distance is only at peak_t
  t1 = (1..peak_t).bsearch { |t| (time - t) * t > distance }
  # the 2nd bsearch will return the first t that does not beat the distance record,
  # so the overall range is "t1 inclusive" to "t2 exclusive"
  t2 = ((peak_t + 1)..(time - 1)).bsearch { |t| (time - t) * t <= distance }

  result = t1.nil? ? 0 : t2 - t1

  puts result
ensure
  f.close
end

puts('== PART1 ==')
part1('test/d6.txt')
part1('input/d6.txt')
puts('== PART2 ==')
part2('test/d6.txt')
part2('input/d6.txt')
