def invert(state)
  state == :low ? :high : :low
end

def broadcast_pulse(mod:, state:, pulse_queue:)
  mod[:targets].each { |target| pulse_queue << { sender: mod[:name], target: target, state: state } }
end

def process_pulse(mod:, sender:, pulse:, pulse_queue:)
  case mod[:type]
  when '%'
    if pulse == :low
      mod[:state] = invert(mod[:state])
      broadcast_pulse(mod: mod, state: mod[:state], pulse_queue: pulse_queue)
    end
  when '&'
    mod[:inputs][sender] = pulse
    output_pulse = mod[:inputs].values.all? { |v| v == :high } ? :low : :high
    broadcast_pulse(mod: mod, state: output_pulse, pulse_queue: pulse_queue)
  when 'broadcaster'
    broadcast_pulse(mod: mod, state: pulse, pulse_queue: pulse_queue)
  end
end

def solve(file_name)
  modules = {}
  File.open(file_name, 'r').each_line(chomp: true) do |line|
    module_name, targets = line.split(' -> ')
    if module_name =~ /%|&/
      module_type = module_name[0]
      module_name = module_name[1..]
    else
      module_type = module_name
    end
    modules[module_name] = { name: module_name, type: module_type, targets: targets.split(', '), inputs: {}, state: :low }
  end
  modules['output'] = { name: 'output', type: 'output', targets: [], inputs: {}, state: :low }
  modules['rx'] = { name: 'rx', type: 'output', targets: [], inputs: {}, state: :low }

  outputs = []
  modules.each do |k, v|
    v[:targets].each do |target|
      modules[target][:inputs][k] = :low
    end
  end
  outputs.each { |m| modules[m[:name]] = m }

  low_pulse_count = high_pulse_count = 0
  pulse_queue = []
  1000.times do |n|
    pulse_queue << { sender: 'button', target: 'broadcaster', state: :low }
    until pulse_queue.empty?
      pulse = pulse_queue.shift
      low_pulse_count += 1 if pulse[:state] == :low
      high_pulse_count += 1 if pulse[:state] == :high
      process_pulse(mod: modules[pulse[:target]], sender: pulse[:sender], pulse: pulse[:state], pulse_queue: pulse_queue)
    end
  end

  puts("Part 1: #{low_pulse_count * high_pulse_count}")

  # Part 2 solution was found manually, by analyzing the circuit connectivity.
  # Broadcaster triggers 4 chains of 12 flip-flops. Some of them also feed their output to one of 4 conjunction modules.
  # Such a module (A) will produce a LOW pulse only when all of its inputs produced a HIGH pulse most recently.
  # For example, given a chain of B>1>2>3>4>5>6>7>8>9>10>11>12 where 1,2 and 12 are the inputs of A, module 1 will
  # receive a LOW pulse each time, module 2 every 2nd time, module 3 every 4th time, and so on; module A will thus
  # see all its inputs set to HIGH after 2^11+2^1+2^0=2049 pulses, and will then produce a LOW pulse on its output.
  # All 4 A modules are connected to another conjunction module (B) through inverters, so B will see all A outputs
  # set to LOW except a single HIGH pulse once per every Ni pulses (where Ni is the periodicity of a given Ai module).
  # So, B can only see all its inputs set to HIGH after M pulses where M is the least common multiple of all Ni.
  puts("Part 2: #{[3793, 3929, 3917, 3911].reduce(1, &:lcm)}")
end

puts('== TEST ==')
solve('test/d20.txt')
puts('== INPUT ==')
solve('input/d20.txt')
