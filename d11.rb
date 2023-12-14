def solve(file_name)
  map = File.open(file_name, 'r', chomp: true).map(&:chars)

  galaxies = []
  row_empty = Array.new(map.size, true)
  col_empty = Array.new(map.first.size, true)
  map.each_with_index do |cells, row|
    cells.each_with_index do |cell, col|
      next unless cell == '#'

      galaxies << [row, col]
      row_empty[row] = false
      col_empty[col] = false
    end
  end

  # for each row index, calculate the index of that row in the expanded universe
  row_exp = []
  row_exp2 = []
  row_index = row_index2 = 0
  row_empty.each do |empty|
    row_exp << row_index
    row_exp2 << row_index2
    row_index += empty ? 2 : 1
    row_index2 += empty ? 1000000 : 1
  end
  # same for columns
  col_exp = []
  col_exp2 = []
  col_index = col_index2 = 0
  col_empty.each do |empty|
    col_exp << col_index
    col_exp2 << col_index2
    col_index += empty ? 2 : 1
    col_index2 += empty ? 1000000 : 1
  end

  result = (0...galaxies.size).map(&:itself).combination(2).map do |m, n|
    r1, c1 = galaxies[m].then { |r, c| [row_exp[r], col_exp[c]]}
    r2, c2 = galaxies[n].then { |r, c| [row_exp[r], col_exp[c]]}

    (r1 - r2).abs + (c1 - c2).abs
  end.sum

  puts("Part 1: #{result}")

  result2 = (0...galaxies.size).map(&:itself).combination(2).map do |m, n|
    r1, c1 = galaxies[m].then { |r, c| [row_exp2[r], col_exp2[c]]}
    r2, c2 = galaxies[n].then { |r, c| [row_exp2[r], col_exp2[c]]}

    (r1 - r2).abs + (c1 - c2).abs
  end.sum

  puts("Part 2: #{result2}")
end

puts("== Test ==")
solve('test/d11.txt')
puts("== Input ==")
solve('input/d11.txt')
