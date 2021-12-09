input = File.open('input.txt').readlines.map {|l| l.strip.split('').map(&:to_i) }

TRACE = false
PART_ONE = false
PART_TWO = true

def trace(*msg)
  if TRACE || ENV['TRACE'] == '1'
    puts format(*msg)
  end
end

def check(x, top, mid, bot)
  foc = mid[x]

  neighbors = [
    top ? top[x] : nil,
    x > 0 ? mid[x - 1] : nil,
    x < mid.size - 1 ? mid[x + 1] : nil,
    bot ? bot[x] : nil
  ].compact

  # trace '---'
  # trace '%i', x
  # trace('check   %s', top[x]) if top
  # trace('check %s %s %s', x > 0 ? mid[x - 1] : '', mid[x], x < mid.size-1 ? mid[x + 1] : '')
  # trace('check   %s', bot[x]) if bot

  neighbors.all? {|n| foc < n}
end

def basin(x, y, grid)
  # starting at grid point, walk out from x,y until hitting 9s
  points = { [x, y] => true }
  walk = [ [x, y] ]

  while walk.size > 0
    start = walk.pop
    x, y = start
    trace 'start at %s', start.inspect


    # up
    trace 'up'
    ny = y - 1
    while ny >= 0
      np = [x, ny]
      break if grid[ny][x] == 9 || points[np]

      trace '  add %s', np.inspect
      walk << np
      points[np] = true
      ny -= 1
    end

    # down
    trace 'down'
    ny = y + 1
    while ny <= (grid.size - 1)
      np = [x, ny]
      break if grid[ny][x] == 9 || points[np]

      trace '  add %s', np.inspect
      walk << np
      points[np] = true
      ny += 1
    end

    # left
    trace 'left'
    nx = x - 1
    while nx >= 0
      np = [nx, y]
      break if grid[y][nx] == 9 || points[np]

      trace '  add %s', np.inspect
      walk << np
      points[np] = true
      nx -= 1
    end

    # right
    trace 'right'
    nx = x + 1
    while nx <= (grid[0].size - 1)
      np = [nx, y]
      break if grid[y][nx] == 9 || points[np]

      trace '  add %s', np.inspect
      walk << np
      points[np] = true
      nx += 1
    end
  end

  trace '[%i, %i] => %s', x, y, points.inspect
  points.keys.size
end

lows = []
kill = false
basins = []

input.each_with_index do |line, y|
  cu = input[y]
  if y != 0
    pr = input[y - 1]
  else
    pr = nil
  end

  if y != input.size - 1
    ne = input[y + 1]
  else
    ne = nil
  end

  line.size.times do |x|
    if check(x, pr, cu, ne)
      lows << cu[x]

      if PART_TWO
        basins << basin(x, y, input)
        puts format('basin at [%i, %i]: %i', x, y, basins.last)
        kill = true
      end
    end

    # break if kill
  end

  # break if kill
end

# puts(format('lows %s', lows.inspect))
if PART_ONE
  puts "PART_ONE: #{ lows.map {|n| n + 1}.sum }"
end

if PART_TWO
  a, b, c = basins.sort[-3..-1]
  puts [a, b, c].inspect
  puts "PART_TWO: #{a * b * c}"
end