def solve(file_name)
  puts("== #{file_name} ==")
  symbols = {}
  numbers = []
  File.open(file_name, 'r').readlines.map(&:chomp).each_with_index do |line, row|
    col = 0
    while col < line.length do
      char = line[col]
      if char == '.'
        # go to the next char
        col += 1
      elsif char < '0' || char > '9'
        # add to symbols
        symbols[[row, col]] = char
        col += 1
      else
        # collect the whole number
        str = char
        col2 = col + 1
        while col2 < line.length do
          char = line[col2]
          if char >= '0' && char <= '9'
            str += char
            col2 += 1
          else
            break
          end
        end
        numbers.push({ number: str, row: row, col: col })
        col = col2
      end
    end
  end
  sum_1 = 0
  gears = {}
  numbers.each do |hash |
    number = hash[:number]
    row = hash[:row]
    col = hash[:col]
    adjacent_to_symbol = false
    adjacent_locations = []
    (col - 1..col + number.length).each do |c|
      adjacent_locations.push([row - 1, c])
      adjacent_locations.push([row + 1, c])
    end
    adjacent_locations.push([row, col - 1])
    adjacent_locations.push([row, col + number.length])
    adjacent_locations.each do |location|
      symbol = symbols[location]
      adjacent_to_symbol = true unless symbol.nil?
      if symbols[location] == '*'
        gears[location] ||= []
        gears[location].push(number.to_i)
      end
    end
    sum_1 += number.to_i if adjacent_to_symbol
  end

  sum_2 = gears.select { |_, adjacent_numbers| adjacent_numbers.size == 2 }
               .values
               .map { |adjacent_numbers| adjacent_numbers[0] * adjacent_numbers[1] }
               .reduce(0, &:+)

  puts("PART 1: #{sum_1}")
  puts("PART 2: #{sum_2}")
end

solve('test/d3.txt')
solve('input/d3.txt')
