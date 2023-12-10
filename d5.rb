MAX_LEN = 2**32 - 1

def read_map(f)
  map = []
  f.readline # map description, ignore
  until f.eof || (line = f.readline.chomp).empty? do
    map << %i[dest src len].zip(line.split(' ').map(&:to_i)).to_h
  end
  map.sort_by! { |entry| entry[:src] }

  next_number = 0
  i = 0
  while i < map.length
    if map[i][:src] > next_number
      new_range = { src: next_number, dest: next_number, len: map[i][:src] - next_number }
      map.insert(i, new_range)
      next_number += new_range[:len]
    else
      next_number = map[i][:src] + map[i][:len]
      i += 1
    end
  end
  map << { src: next_number, dest: next_number, len: MAX_LEN } # add last range

  map
end

def aggregate_maps(map1, map2)
  map = []
  map1.each do |range1|
    i = map2.bsearch_index { |range| range1[:dest] - range[:src] < range[:len] }
    loop do
      range2 = map2[i]
      new_dest = range2[:dest] + range1[:dest] - range2[:src]
      if range1[:dest] + range1[:len] <= range2[:src] + range2[:len]
        # range1 is completely contained in range2
        map << { src: range1[:src], dest: new_dest, len: range1[:len] }
        break
      end
      # range1 needs to be split: add matching part to the map...
      new_len = range2[:src] + range2[:len] - range1[:dest]
      map << { src: range1[:src], dest: new_dest, len: new_len }
      # ...and continue with the remaining part of range1, which should match the subsequent range from map2
      range1 = { src: range1[:src] + new_len, dest: range1[:dest] + new_len, len: range1[:len] - new_len }
      i += 1
    end
  end

  map
end

def location(seed, maps)
  n = seed
  maps.each do |map|
    match = map.find { |entry| n >= entry[:src] && n < entry[:src] + entry[:len] }
    n += match[:dest] - match[:src] if match
  end

  n
end

def part1(file_name)
  f = File.open(file_name, 'r')
  seeds = f.readline.split(':').last.split(' ').map(&:to_i)
  f.readline
  maps = []
  maps << read_map(f) until f.eof

  puts(seeds.map { |seed| location(seed, maps) }.min)
end

def part2(file_name)
  f = File.open(file_name, 'r')
  seed_map = f.readline.split(':').last.split(' ').map(&:to_i) # plain list of values
              .each_slice(2) # pairs
              .map { |src, len| { src: src, dest: src, len: len } } # represent seeds as an identity map
              .sort_by! { |entry| entry[:src] }
  f.readline
  maps = []
  maps << read_map(f) until f.eof

  seed_to_location_map = maps.reduce(seed_map, &method(:aggregate_maps))

  puts(seed_to_location_map.map { |entry| entry[:dest] }.min)
end

puts('== PART1 ==')
part1('test/d5.txt')
part1('input/d5.txt')
puts('== PART2 ==')
part2('test/d5.txt')
part2('input/d5.txt')
