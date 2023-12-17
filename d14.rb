def north_support_load(map)
  load = 0
  rows = map.length
  cols = map[0].length
  (0...rows).each do |row|
    (0...cols).each do |col|
      load += rows - row if map[row][col] == 'O'
    end
  end

  load
end

def tilt_north(map)
  rows = map.length
  cols = map[0].length
  (0...cols).each do |col|
    top_row = 0
    (0...rows).each do |row|
      case map[row][col]
      when '#'
        top_row = row + 1
      when 'O'
        map[row][col] = '.'
        map[top_row][col] = 'O'
        top_row += 1
      end
    end
  end
end

def tilt_south(map)
  rows = map.length
  cols = map[0].length
  (0...cols).each do |col|
    bottom_row = rows - 1
    (0...rows).reverse_each do |row|
      case map[row][col]
      when '#'
        bottom_row = row - 1
      when 'O'
        map[row][col] = '.'
        map[bottom_row][col] = 'O'
        bottom_row -= 1
      end
    end
  end
end

def tilt_west(map)
  rows = map.length
  cols = map[0].length
  (0...rows).each do |row|
    left_col = 0
    (0...cols).each do |col|
      case map[row][col]
      when '#'
        left_col = col + 1
      when 'O'
        map[row][col] = '.'
        map[row][left_col] = 'O'
        left_col += 1
      end
    end
  end
end

def tilt_east(map)
  rows = map.length
  cols = map[0].length
  (0...rows).each do |row|
    right_col = cols - 1
    (0...cols).reverse_each do |col|
      case map[row][col]
      when '#'
        right_col = col - 1
      when 'O'
        map[row][col] = '.'
        map[row][right_col] = 'O'
        right_col -= 1
      end
    end
  end
end

def cycle(map)
  tilt_north(map)
  tilt_west(map)
  tilt_south(map)
  tilt_east(map)
end

def solve(file_name)
  map = File.open(file_name, 'r').readlines(chomp: true).map(&:chars)

  tilt_north(map.dup)

  puts("Part1: #{north_support_load(map)}")

  history = {}
  loads = {}
  n = 0
  loop do
    n += 1
    cycle(map)
    load = north_support_load(map)
    hash = map.hash
    prev_n = history[hash]
    if prev_n
      cycle_length = n - prev_n
      result = loads[prev_n + ((1_000_000_000 - prev_n) % cycle_length)]
      puts("Part2: #{result}")
      break
    end
    history[hash] = n
    loads[n] = load
  end
end

puts('== TEST ==')
solve('test/d14.txt')
puts('== INPUT ==')
solve('input/d14.txt')
