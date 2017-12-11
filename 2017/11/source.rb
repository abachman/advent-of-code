# --- Day 11: Hex Ed ---
#
# Crossing the bridge, you've barely reached the other side of the stream when
# a program comes up to you, clearly in distress. "It's my child process," she
# says, "he's gotten lost in an infinite grid!"
#
# Fortunately for her, you have plenty of experience with infinite grids.
#
# Unfortunately for you, it's a hex grid.
#
# The hexagons ("hexes") in this grid are aligned such that adjacent hexes can
# be found to the north, northeast, southeast, south, southwest, and northwest:
#
#   \ n  /
# nw +--+ ne
#   /    \
# -+      +-
#   \    /
# sw +--+ se
#   / s  \
#
# You have the path the child process took. Starting where he started, you need
# to determine the fewest number of steps required to reach him. (A "step"
# means to move from the hex you are in to any adjacent hex.)
#
# For example:
#
# - ne,ne,ne is 3 steps away.
# - ne,ne,sw,sw is 0 steps away (back where you started).
# - ne,ne,s,s is 2 steps away (se,se).
# - se,sw,se,sw,sw is 3 steps away (s,s,sw).
#
# To begin, get your puzzle input.
#

input = open('input.txt').read().strip().split(',')

test1 = 'ne,ne,ne'.split(',')
test2 = 'ne,ne,sw,sw'.split(',')
test3 = 'ne,ne,s,s'.split(',')
test4 = 'se,sw,se,sw,sw'.split(',')

def distance(a)
  # divide by 2 since each "step" updates two coordinates
  return (a[0].abs + a[1].abs + a[2].abs) / 2
end

MOVES = {
  'n'  => [0, +1, -1],
  'ne' => [+1, 0, -1],
  'se' => [+1, -1, 0],
  's'  => [0, -1, +1],
  'sw' => [-1, 0, +1],
  'nw' => [-1, +1, 0],
}

def move(point, dir)
  ddir = MOVES[dir]

  # modify point in place
  point.each_with_index do |v, idx|
    point[idx] = v + ddir[idx]
  end
end

def solve(input)
  #         x, y, z
  coords = [0, 0, 0]
  max = 0
  puts "START "

  input.each do |direction|
    move(coords, direction)
    d = distance(coords)
    max = d > max ? d : max
  end
  puts "  #{input.size} MOVES LATER"
  puts "  FINAL #{coords.inspect}"
  puts "  DIST  #{distance(coords)}"
  puts "  MAX   #{max}"
end

solve(input)
# [test1, test2, test3, test4].each do |input|
#   solve(input)
# end
