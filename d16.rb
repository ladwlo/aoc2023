require 'set'

MIRROR_FWD = {
  right: :up,
  left: :down,
  up: :right,
  down: :left
}

MIRROR_BWD = {
  right: :down,
  left: :up,
  up: :left,
  down: :right
}

def energized_cells(map, start_row, start_col, start_dir)
  energized = Array.new(map.size) { Array.new(map.first.size, false) }
  cell_beams = Set.new
  rows, cols = [map.size, map.first.size]
  beams = [{ r: start_row, c: start_col, dir: start_dir }]
  until beams.empty?
    beam = beams.shift
    r, c, dir = beam.values_at(:r, :c, :dir)
    loop do
      cell = map[r][c]
      case cell
      when '|'
        if dir == :right || dir == :left
          # split beam: this beam will go upwards, the new beam will go downwards
          dir = :up
          beams << { r: r, c: c, dir: :down }
        end
      when '-'
        if dir == :up || dir == :down
          # split beam: this beam will go left, the new beam will go right
          dir = :left
          beams << { r: r, c: c, dir: :right }
        end
      when '/'
        dir = MIRROR_FWD[dir]
      when '\\'
        dir = MIRROR_BWD[dir]
      end

      key = "#{r}:#{c}:#{dir}"
      break if cell_beams.include?(key)

      cell_beams << key
      energized[r][c] = true
      case dir
      when :right
        c += 1
      when :left
        c -= 1
      when :up
        r -= 1
      when :down
        r += 1
      end
      break if r < 0 || r >= rows || c < 0 || c >= cols
    end
  end

  energized.flatten.count(true)
end

def solve(file_name)
  map = File.open(file_name, 'r').readlines(chomp: true).map(&:chars)
  result1 = energized_cells(map, 0, 0, :right)
  puts("Part 1: #{result1}")

  rows, cols = [map.size, map.first.size]
  results = []
  (0...rows).each do |r|
    results << energized_cells(map, r, 0, :right)
    results << energized_cells(map, r, cols - 1, :left)
  end
  (0...cols).each do |c|
    results << energized_cells(map, 0, c, :down)
    results << energized_cells(map, rows - 1, c, :up)
  end

  puts("Part 2: #{results.max}")
end

solve('test/d16.txt')
solve('input/d16.txt')