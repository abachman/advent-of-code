input = File.open('input.txt').readlines.map {|l| l.strip.split('').map(&:to_i) }

TIMES = 100
TRACE = true
PART_ONE = true
PART_TWO = false

def trace(*msg)
  if TRACE || ENV['TRACE'] == '1'
    puts format(*msg)
  end
end

# bold zero
def see_n(n)
  n == 0 ?
    "\e[1m#{n}\e[0m" :
    n.to_s
end

# input is a grid
def see(grid)
  grid.each do |line|
    trace "#{line.map {|n| see_n(n)}.join('')}"
  end
end

def step(g)
  fcount = 0
  flash = []
  flashed = {}

  h = g.size
  w = g[0].size

  inc = -> (g, x, y) {
    p = [x, y]
    if flashed[p]
      return
    end

    g[y][x] += 1
    if g[y][x] > 9
      fcount += 1
      flash << p
      g[y][x] = 0
      flashed[p] = true
    end
  }

  # first, loop through every grid point and bump 1
  (0..(h - 1)).each do |y|
    (0..(w - 1)).each do |x|
      inc.call g, x, y
    end
  end

  # next, bump each flash neighbor 1
  while flash.size > 0
    x, y = flash.shift
    (-1..1).each do |dy|
      (-1..1).each do |dx|
        nx = x + dx
        ny = y + dy
        if nx >= 0 && nx < w && ny >= 0 && ny < h
          inc.call g, nx, ny
        end
      end
    end
  end

  fcount
end

def synced?(g)
  g.all? { |row| row.all? { |n| n == 0 } }
end

trace 'START'
see input

total = 0

TIMES.times do |n|
  total += step input
  if (n + 1) % 10 == 0
    trace ''
    trace 'After step %i:', n + 1
    see input
  end
end

puts
puts "PART_ONE FLASHES: #{total}"

steps = TIMES
until synced?(input)
  steps += 1
  step input

  if steps % 10 == 0
    trace ''
    trace 'After step %i:', steps
    see input
  end
end

puts "PART_TWO SYNC ON: #{steps}"