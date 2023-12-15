MEMO = {}

def memoize(key, value)
  MEMO[key] = value

  value
end

def matches?(group, template)
  group.zip(template).all? { |g, t| g == '?' || g == t }
end

def arrangements(row, runs)
  key = "#{row}:#{runs.join(',')}"
  return MEMO[key] if MEMO.key?(key)

  return memoize(key, row.include?('#') ? 0 : 1) if runs.empty?

  min_length = runs.sum + runs.length + 1
  return memoize(key, 0) if row.length < min_length

  run_length = runs.first
  template = ".#{'#' * run_length}.".chars
  group_length = run_length + 2
  max_offset = (row.index('#') || row.length - group_length + 1) - 1
  counts = row.each_cons(group_length).each_with_index
              .filter { |group, offset| offset <= max_offset && matches?(group, template) }
              .map { |_group, offset| arrangements(row[offset + group_length - 1..], runs[1..]) }

  memoize(key, counts.sum)
end

def arrangements2(groups, runs)
  key = "#{groups.join(',')}:#{runs.join(',')}"
  return MEMO[key] if MEMO.key?(key)

  return memoize(key, runs.empty? ? 1 : 0) if groups.empty?

  return memoize(key, groups.any? { |g| g.include?('#') } ? 0 : 1) if runs.empty?

  return memoize(key, 0) if groups.map(&:size).sum < runs.sum

  first_group_as_chars = ".#{groups.first}.".chars
  remaining_groups = groups[1..]

  counts = []
  runs_to_match = []
  remaining_runs = runs.dup
  loop do
    counts << arrangements(first_group_as_chars, runs_to_match) * arrangements2(remaining_groups, remaining_runs)
    break if remaining_runs.empty?

    runs_to_match << remaining_runs.shift
  end

  memoize(key, counts.sum)
end

def solve(file_name)
  result = File.open(file_name, 'r', chomp: true).map do |line|
    row, runs = line.split(' ').then { |row, runs| [".#{row}.".chars, runs.split(',').map(&:to_i)] }
    arrangements(row, runs)
  end.sum

  puts("Part 1: #{result}")
end

def solve2(file_name)
  result = File.open(file_name, 'r', chomp: true).map do |line|
    groups, runs = line.split(' ')
                       .then { |row, runs| [Array.new(5, row).join('?'), Array.new(5, runs).join(',')] }
                       .then { |row, runs| [row.split('.').reject(&:empty?), runs.split(',').map(&:to_i)] }
    arrangements2(groups, runs)
  end.sum

  puts("Part 2: #{result}")
end

puts("== TEST ==")
solve('test/d12.txt')
solve2('test/d12.txt')
puts("== INPUT ==")
solve('input/d12.txt')
solve2('input/d12.txt')
