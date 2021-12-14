input = File.open('input.txt').readlines.map {|l| l.strip }

TRACE = true
PART_ONE = true
PART_TWO = false

def trace(*msg)
  if TRACE || ENV['TRACE'] == '1'
    puts format(*msg)
  end
end

def render(map)
  out = []

  map.each do |row|
    out << ''
    row.each do |col|
      out[-1] += (col == 1) ? '#' : '.'
    end
  end

  out.join("\n")
end

def parse(lines)
  mapping = true
  inst = []
  coords = {}
  maxx = -1
  maxy = -1

  lines.each do |line|
    if line == ''
      mapping = false
      next
    end

    if mapping
      coord = line.split(',').map(&:to_i)
      x, y = coord
      maxx = [x, maxx].max
      maxy = [y, maxy].max

      coords[line] = true
    else
      i = line.sub('fold along ', '').split('=')
      inst << [ i[0], i[1].to_i ]
    end
  end

  trace 'max: [%i, %i]', maxx, maxy

  map = []
  (maxy + 1).times do |y|
    y % 100 == 0 ? trace('row %i', y) : nil
    map << []
    (maxx + 1).times do |x|
      map.last << (coords["#{x},#{y}"] ? 1 : 0)
    end
  end

  trace 'ready'

  [map, inst]
end

def fold(map, at)
  dir, idx = at
  case dir
  when 'x'
    # right over left
    hold = map.map {|row| row[0, idx]}
    cover = map.map {|row| row[idx, row.length].reverse }

  when 'y'
    # bottom up
    hold = map[0, idx]
    cover = map[idx, map.length].reverse
  end

  new_map = hold.zip(cover).map {|row|
    (row[0].zip(row[1])).map {|(a, b)|
      a | b
    }
  }

  new_map
end

def count(map)
  sum = 0

  map.each do |row|
    row.each do |col|
      sum += col
    end
  end

  sum
end

map, instructions = parse(input)

trace 'inst: %s', instructions.inspect
trace 'start (%i visible)', count(map)
# trace render(map)

instructions.each do |inst|
  map = fold(map, inst)
  trace ''
  trace 'after %s (%i visible)', inst.inspect, count(map)
  # trace render(map)

  # break
end

trace ''
trace 'final'
trace render(map)