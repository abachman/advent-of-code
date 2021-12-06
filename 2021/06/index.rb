input = File.open('input.txt').readlines[0].strip.split(',').map(&:to_i)

TRACE = false

def trace(*msg)
  if TRACE || ENV['TRACE'] == '1'
    puts format(*msg)
  end
end

fishies = {}

input.each do |f|
  fishies[f] ||= 0
  fishies[f] += 1
end

trace fishies.inspect

days = 256
counter = 0

days.times do |n|
  trace 'day: %i',  n + 1
  trace 'fish: %s', fishies.inspect
  next_fishies = Hash[ (0..8).map {|n| [n, 0]} ]

  # step each counter down, all 0s become 6s and add an extra 1 to 8 group
  (1..8).each do |n|
    next_fishies[n - 1] = fishies[n]
  end

  if fishies[0]
    next_fishies[8] = fishies[0]
    next_fishies[6] ||= 0
    next_fishies[6] += fishies[0]
  end

  fishies = next_fishies
end

puts fishies.values.sum