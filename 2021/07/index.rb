input = File.open('input.txt').readlines.map(&:strip)

PART_ONE = true
PART_TWO = false
TRACE = true

def trace(*msg)
  if TRACE || ENV['TRACE'] == '1'
    puts format(*msg)
  end
end

# return a list of coordinate pairs
def parse(line)
  line.split(',').map(&:to_i).sort
end

def score(carbs, pos)
  carbs.map {|p|
    n = (p - pos).abs
    if PART_TWO
      s = (n / 2) * (n + 1)
      if n % 2 != 0
        s += n/2 + 1
      end
      # trace '%i -> %i: %i', p, pos, s
      n = s
    end
    n
  }.sum
end

crabs = parse(input[0])

prev = nil
(crabs.first..crabs.last).each do |p|
  s = score(crabs, p)

  if prev && s < prev
    puts format('- %4i %4i', p, s)
  elsif prev
    # quit checking when fuel use starts going up
    break
  end

  prev = s
end
