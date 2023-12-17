def compute_hash(s)
  n = 0
  s.each_char { |c| n = ((n + c.ord) * 17) & 0xff }

  n
end

def solve(file_name)
  steps = File.open(file_name, 'r').readline(chomp: true).split(',')
  result1 = steps.map { |s| compute_hash(s) }.sum

  puts("Part 1: #{result1}")

  boxes = {}
  256.times { |i| boxes[i] = { index: i, slots: [] } }
  steps.each do |step|
    n = step.index(/[-=]/)
    label = step[0...n]
    op = step[n]
    value = step[(n + 1)..].to_i
    hash = compute_hash(label)
    slots = boxes[hash][:slots]
    n = slots.index { |v| v[0] == label }
    case op
    when '-'
      slots.delete_at(n) if n
    when '='
      if n
        slots[n][1] = value
      else
        slots << [label, value]
      end
    end
  end

  result2 = 0
  boxes.each_value do |box_contents|
    box_number, slots = box_contents.values_at(:index, :slots)
    slots.each_with_index do |lens, slot_number|
      power = (1 + box_number) * (1 + slot_number) * lens[1]
      result2 += power
    end
  end

  puts("Part 2: #{result2}")
end

puts("== TEST ==")
solve('test/d15.txt')
puts("== INPUT ==")
solve('input/d15.txt')