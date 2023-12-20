def accepted?(part, workflows)
  rules = workflows['in'].dup
  loop do
    rule = rules.shift
    target = if rule.include?(':')
               condition, target = rule.split(':')
               attr, op, val = condition.match(/(.+)(<|>)(.+)/).captures.then { |a, op, v| [a, op, v.to_i] }
               case op
               when '<'
                 target if part[attr] < val
               when '>'
                 target if part[attr] > val
               end
             else
               rule # rule contains only target
             end
    next unless target

    case target
    when 'A'
      return true
    when 'R'
      return false
    end

    rules = workflows[target].dup
  end
end

def accepted_count(bounds, rules, workflows)
  rules = rules.dup
  rule = rules.shift
  unless rule.include?(':')
    # rule contains only target
    target = rule
    case target
    when 'A'
      return bounds.values.map { |b| b[1] - b[0] + 1 }.reduce(&:*)
    when 'R'
      return 0
    end

    rules = workflows[target].dup
    rule = rules.shift
  end

  condition, target = rule.split(':')
  attr, op, val = condition.match(/(.+)(<|>)(.+)/).captures.then { |a, op, v| [a, op, v.to_i] }
  min_bound, max_bound = bounds[attr]
  case op
  when '<'
    if val > min_bound
      if val < max_bound
        # split bounds: process [min_bound, val - 1] with rule's target and [val, max_bound] with the next rule
        c1 = accepted_count(bounds.merge(attr => [min_bound, val - 1]), [target], workflows)
        c2 = accepted_count(bounds.merge(attr => [val, max_bound]), rules, workflows)
        c1 + c2
      else
        # condition always met within current bounds, move to the rule's target
        accepted_count(bounds, [target], workflows)
      end
    else
      # condition never met within current bounds, just process the next rule
      accepted_count(bounds, rules, workflows)
    end
  when '>'
    if val < max_bound
      if val > min_bound
        # split bounds: process [min_bound, val] with the next rule and [val + 1, max_bound] with the rule's target
        c1 = accepted_count(bounds.merge(attr => [min_bound, val]), rules, workflows)
        c2 = accepted_count(bounds.merge(attr => [val + 1, max_bound]), [target], workflows)
        c1 + c2
      else
        # condition always met within current bounds, move to the rule's target
        accepted_count(bounds, [target], workflows)
      end
    else
      # condition never met within current bounds, just process the next rule
      accepted_count(bounds, rules, workflows)
    end
  end
end

def solve(file_name)
  f = File.open(file_name, 'r')
  workflows = {}
  until (line = f.readline(chomp: true)).empty?
    id, workflow = line.match(/(.+){(.*)}/).captures
    workflows[id] = workflow.split(',')
  end
  parts = []
  until f.eof
    line = f.readline(chomp: true)
    parts << line[1...(line.length - 1)].split(',')
                                        .map { |s| s.split('=').then { |n, v| [n, v.to_i] } }
                                        .to_h
  end
  f.close

  puts("Part 1: #{parts.filter { |part| accepted?(part, workflows) }.map(&:values).map(&:sum).sum}")

  bounds = %w[x m a s].each_with_object({}) { |a, h| h[a] = [1, 4000] }
  rules = workflows['in']
  result2 = accepted_count(bounds, rules, workflows)

  puts("Part 2: #{result2}")
end

puts('== TEST ==')
solve('test/d19.txt')
puts('== INPUT ==')
solve('input/d19.txt')
