def part1(file_name)
  id_sum = 0
  max_cubes = { red: 12, green: 13, blue:14 }
  File.open(file_name, 'r').readlines.map do |line|
    game_info, cube_sets = line.split(': ')
    game_id = game_info.sub('Game ', '').to_i
    game_possible = true
    cube_sets.split('; ').map do |cube_set|
      cube_set.split(', ').map do |subset|
        str_count, str_color = subset.split(' ')
        count = str_count.to_i
        color = str_color.to_sym
        game_possible = false if count.to_i > max_cubes[color]
      end
    end
    id_sum += game_id if game_possible
  end

  id_sum
end

def part2(file_name)
  power_sum = 0
  File.open(file_name, 'r').readlines.map do |line|
    min_cubes = { red: 0, green: 0, blue: 0 }
    cube_sets = line.split(': ').last
    cube_sets.split('; ').map do |cube_set|
      cube_set.split(', ').map do |subset|
        str_count, str_color = subset.split(' ')
        count = str_count.to_i
        color = str_color.to_sym
        min_cubes[color] = [min_cubes[color], count].max
      end
    end
    power_sum += min_cubes.values.reduce(1, :*)
  end

  power_sum
end

puts '== PART 1 =='
puts part1('test/d2.txt')
puts part1('input/d2.txt')
puts '== PART 2 =='
puts part2('test/d2.txt')
puts part2('input/d2.txt')
