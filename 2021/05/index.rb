
input = File.open('input.txt').readlines.map(&:strip)

PART_ONE = false
PART_TWO = true
TRACE = false

def trace(*msg)
  if TRACE || ENV['TRACE'] == '1'
    puts format(*msg)
  end
end

# return a list of coordinate pairs
def parse(line)
  a, b = line.split(' -> ')
  a = a.split(',').map(&:to_i)
  b = b.split(',').map(&:to_i)
  [ a, b ]
end

def render(s)
  x_max = s.keys.sort {|a, b| a[0] <=> b[0]}.last[0]
  y_max = s.keys.sort {|a, b| a[1] <=> b[1]}.last[1]

  trace "0,0 -> %i,%i", x_max, y_max

  (0..y_max).each do |y|
    (0..x_max).each do |x|
      key = [x, y]
      print(s.has_key?(key) ? s[key] : '.')
    end
    print "\n"
  end
end

def pairs(a, b)
  x_min = a[0] < b[0] ? a[0] : b[0]
  x_max = a[0] > b[0] ? a[0] : b[0]
  y_min = a[1] < b[1] ? a[1] : b[1]
  y_max = a[1] > b[1] ? a[1] : b[1]

  if a[0] == b[0]
    # vert
    trace 'vert %i -> %i', a[1], b[1]

    (0..(y_max - y_min)).map do |n|
      [
        a[0], y_min + n
      ]
    end
  elsif a[1] == b[1]
    trace 'horiz %i -> %i', a[0], b[0]

    (0..(x_max - x_min)).map do |n|
      [
        x_min + n, a[1]
      ]
    end
  else
    trace 'diag'

    if PART_TWO
      # 45 degree lines means x or y can be used as a counter.
      # we'll always go left -> right, but need to sort out
      # whether line goes up or down
      f = x_min == a[0] ? a : b
      l = x_max == a[0] ? a : b

      #                   dn   up
      dir = f[1] > l[1] ? -1 : 1

      (0..(x_max - x_min)).map do |n|
        [
          f[0] + n, f[1] + (n * dir)
        ]
      end
    else
      []
    end
  end
end

# mark all seafloor coordinates between a + b
def vent(s, points)
  points.each do |point|
    s[point] ||= 0
    s[point] += 1
  end
end

# track by coord hash
seafloor = {}

input.each do |line|
  trace "-----"
  trace line
  _pairs = pairs(*parse(line))
  trace _pairs.inspect
  vent seafloor, _pairs
end

# puts
# render seafloor

puts
if PART_ONE
  print 'PART_ONE: '
else
  print 'PART_TWO: '
end
puts seafloor.values.select {|v| v >= 2}.size

