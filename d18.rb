def interior_cells(h_sections, v_sections, row)
  # create an ordered list of contiguous cell chains in this row
  # make an N-cell chain for each h-section in this row and a 1-cell chain for each intersecting vertical section
  chains = h_sections[row] || []
  chains += v_sections.filter { |_, vss| vss.find { |vs| vs[0] < row && row < vs[1] } }.map { |c, _| [c, c] }
  chains.sort!

  # traverse the chains, counting gaps between consecutive chains if the 'inside' flag is true
  # flip the inside/outside state when passing through any chain that continues both upwards and downwards
  prev_column = nil
  inside = false
  cell_count = 0
  chains.each do |c1, c2|
    cell_count += c1 - prev_column - 1 if prev_column && inside
    # does this horizontal section continue both 'up' and 'down'?
    r_min, r_max = (v_sections[c1] + v_sections[c2]).filter { |r1, r2| r1 <= row && row <= r2 }.flatten.minmax
    inside = !inside if r_min < row && row < r_max
    prev_column = c2
  end

  cell_count
end

DIRS = %w[R D L U].freeze

def solve(file_name, part2 = false)
  instructions = File.open(file_name, 'r')
                     .readlines(chomp: true)
                     .map { |line| line.split(' ') }
                     .map { |d, n, c| [d, n.to_i, c.match(/\(#(.*)\)/).captures.first] }

  r = c = 0
  h_sections = {}
  v_sections = {}
  boundary_size = 0
  instructions.each do |dir, num, color|
    if part2
      num = color[0..4].to_i(base = 16)
      dir = DIRS[color[5].to_i]
      # decode color into dir & nym
    end
    boundary_size += num
    case dir
    when 'L'
      c -= num
      sections = h_sections[r]
      h_sections[r] = sections = [] if sections.nil?
      sections << [c, c + num]
    when 'R'
      c += num
      sections = h_sections[r]
      h_sections[r] = sections = [] if sections.nil?
      sections << [c - num, c]
    when 'U'
      r -= num
      sections = v_sections[c]
      v_sections[c] = sections = [] if sections.nil?
      sections << [r, r + num]
    when 'D'
      r += num
      sections = v_sections[c]
      v_sections[c] = sections = [] if sections.nil?
      sections << [r - num, r]
    end
  end
  h_sections.transform_values!(&:sort) # order horizontal sections in each row by their column range
  v_sections.transform_values!(&:sort) # order vertical sections in each column by their row range

  # algorithm summary:
  # - consider rows that contain any horizontal sections (that's only a small fraction of all rows)
  # - count interior cells in those rows (note: the first and last rows cannot contain any interior cells)
  # - between each consecutive pair of such rows, there will be N identical rows (N could be a very large number)
  #   with some vertical sections intersecting them; count interior cells in one such row and multiply by N
  cell_count = boundary_size
  rows_with_horizontal_sections = h_sections.keys.sort
  rows_with_horizontal_sections.each_cons(2) do |row, next_row|
    cell_count += interior_cells(h_sections, v_sections, row)
    cell_count += (next_row - row - 1) * interior_cells(h_sections, v_sections, row + 1)
  end

  puts("#{cell_count}")
end

puts("== PART 1 ==")
solve('test/d18.txt')
solve('input/d18.txt')
puts("== PART 2 ==")
solve('test/d18.txt', true)
solve('input/d18.txt', true)
