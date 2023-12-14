DIR_UP = [-1, 0].freeze
DIR_DOWN = [1, 0].freeze
DIR_LEFT = [0, -1].freeze
DIR_RIGHT = [0, 1].freeze

REVERSE_DIRS = {
  DIR_UP => DIR_DOWN,
  DIR_DOWN => DIR_UP,
  DIR_LEFT => DIR_RIGHT,
  DIR_RIGHT => DIR_LEFT
}.freeze

CONNECTIONS = {
  '.' => [],
  '|' => [DIR_UP, DIR_DOWN],
  '-' => [DIR_LEFT, DIR_RIGHT],
  'F' => [DIR_DOWN, DIR_RIGHT],
  '7' => [DIR_DOWN, DIR_LEFT],
  'L' => [DIR_UP, DIR_RIGHT],
  'J' => [DIR_UP, DIR_LEFT]
}.transform_values(&:sort!).freeze # sort entries to make it easier to compare

def pipe_at(map, row, col)
  return '.' if row < 0 || col < 0 || row >= map.size || col >= map.first.size

  map[row][col]
end

def deduce_pipe_kind(map, pos)
  row, col = pos
  dirs = []
  dirs << DIR_UP if CONNECTIONS[pipe_at(map, row - 1, col)].include?(DIR_DOWN)
  dirs << DIR_DOWN if CONNECTIONS[pipe_at(map, row + 1, col)].include?(DIR_UP)
  dirs << DIR_LEFT if CONNECTIONS[pipe_at(map, row, col - 1)].include?(DIR_RIGHT)
  dirs << DIR_RIGHT if CONNECTIONS[pipe_at(map, row, col + 1)].include?(DIR_LEFT)

  CONNECTIONS.key(dirs.sort) # pipe kind that matches the connected neighbours
end

def move(pos, pipe, last_dir)
  next_dir = CONNECTIONS[pipe].reject { |dir| dir == REVERSE_DIRS[last_dir] }.first
  next_pos = [pos.first + next_dir.first, pos.last + next_dir.last]

  [next_pos, next_dir]
end

def solve(file_name)
  map = []
  current_pos = nil
  File.open(file_name, 'r').each_with_index do |line, row|
    s_index = line.index('S')
    current_pos = [row, s_index] if s_index
    map << line.chomp.chars
  end
  map2 = Array.new(map.size) { Array.new(map.first.size) { '.' } }
  current_pipe = deduce_pipe_kind(map, current_pos)
  last_dir = nil
  loop_length = 0
  while current_pipe != 'S'
    map2[current_pos.first][current_pos.last] = current_pipe # mark tiles that make the main loop
    current_pos, last_dir = move(current_pos, current_pipe, last_dir)
    current_pipe = map[current_pos.first][current_pos.last]
    loop_length += 1
  end

  puts("part 1: #{loop_length / 2}")

  inner_tile_count = 0
  inside = false
  map2.each do |row|
    start_dir = nil # when inside a horizontal section, the direction from which the loop entered the section
    row.each do |tile|
      case tile
      when '.'
        inner_tile_count += 1 if inside
      when '-'
        next
      when '|'
        inside = !inside
      when 'F'
        start_dir = DIR_DOWN
      when 'L'
        start_dir = DIR_UP
      when '7'
        inside = !inside if start_dir == DIR_UP
      when 'J'
        inside = !inside if start_dir == DIR_DOWN
      end
    end
  end

  puts("part 2: #{inner_tile_count}")
end

puts("== TEST A ==")
solve('test/d10a.txt')

puts("== TEST B ==")
solve('test/d10b.txt')

puts(+"== INPUT ==")
solve('input/d10.txt')
