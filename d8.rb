def part1(file_name)
  f = File.open(file_name, 'r')
  directions = f.readline.chomp.chars
  f.readline
  map = {}
  until f.eof
    src, left, right = f.readline.chomp.split(/ = \(|, |\)/)[0..2]
    map[src] = { 'L' => left, 'R' => right }
  end

  steps = 0
  location = 'AAA'
  until location == 'ZZZ'
    direction = directions[steps % directions.length]
    steps += 1
    location = map[location][direction]
  end

  puts(steps)
ensure
  f.close
end

def gcd(a, b)
  return a if b == 0

  gcd(b, a % b)
end

def lcm(a, b)
  a * (b / gcd(a, b))
end

def part2(file_name)
  f = File.open(file_name, 'r')
  directions = f.readline.chomp.chars
  f.readline
  map = {}
  until f.eof
    src, left, right = f.readline.chomp.split(/ = \(|, |\)/)[0..2]
    map[src] = { 'L' => left, 'R' => right }
  end

  locations = map.keys.select { |k| k.end_with?('A') }
  # find how many steps are needed for each starting location
  steps = locations.map do |location|
    count = 0
    until location.end_with?('Z')
      direction = directions[count % directions.length]
      count += 1
      location = map[location][direction]
    end

    count
  end
  # find the least common multiple of all the step counts
  result = steps.reduce(1) { |acc, x| lcm(acc, x) }

  puts(result)
ensure
  f.close
end

puts("== PART 1 ==")
part1("test/d8.txt")
part1("input/d8.txt")

puts("== PART 2 ==")
part2("test/d8.txt")
part2("input/d8.txt")
