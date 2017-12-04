# --- Day 3: Spiral Memory ---
#
# You come across an experimental new kind of memory stored on an infinite
# two-dimensional grid.
#
# Each square on the grid is allocated in a spiral pattern starting at a
# location marked 1 and then counting up while spiraling outward. For example,
# the first few squares are allocated like this:
#
#   17  16  15  14  13
#   18   5   4   3  12
#   19   6   1   2  11
#   20   7   8   9  10
#   21  22  23---> ...
#
# While this is very space-efficient (no squares are skipped), requested data
# must be carried back to square 1 (the location of the only access port for
# this memory system) by programs that can only move up, down, left, or right.
# They always take the shortest path: the Manhattan Distance between the
# location of the data and square 1.
#
# For example:
#
# - Data from square 1 is carried 0 steps, since it's at the access port.
# - Data from square 12 is carried 3 steps, such as: down, left, left.
# - Data from square 23 is carried only 2 steps: up twice.
# - Data from square 1024 must be carried 31 steps.
#
# How many steps are required to carry the data from the square identified in
# your puzzle input all the way to the access port?
#
# Your puzzle input is 325489.

input = 325489

PART_ONE = false
# 0, 0 -> 1
# 1, 0 -> 2
# 1, 1 -> 3
# 0, 1 -> 4
# -1, 1 -> 5
# -1, 0 -> 6

map = {}

MOVEMENT = {
  r: [1, 0],
  u: [0, 1],
  l: [-1, 0],
  d: [0, -1],
}

turn = {
  r: :u,
  u: :l,
  l: :d,
  d: :r
}

c = [0,0]
n = 1

map[c.to_s] = n
dir = :r

def move(coords, dir)
  [
    coords[0] + MOVEMENT[dir][0],
    coords[1] + MOVEMENT[dir][1]
  ]
end

def neighbors(coord)
  [
    [-1, 1],  [0, 1],  [1, 1],
    [-1, 0],           [1, 0],
    [-1, -1], [0, -1], [1, -1]
  ].map do |modifier|
    [
      modifier[0] + coord[0],
      modifier[1] + coord[1],
    ]
  end
end

def sum_of_neighbors(map, coords)
  sum_of_neighbors = 0
  # puts "ORIGIN #{ coords.to_s }"
  neighbors(coords).each do |n_coords|
    # puts "  NEIGHBOR #{ n_coords.to_s } #{ map[n_coords.to_s].to_i }"
    sum_of_neighbors += map[n_coords.to_s].to_i
  end
  # puts "SUM #{ sum_of_neighbors }"
  sum_of_neighbors
end

c = move(c, dir)

if PART_ONE
  n += 1
else
  n = sum_of_neighbors(map, c)
end
map[c.to_s] = n

# start at 0,0
# face R
# loop:
#   move forward
#   if L is open, turn L
loop do
  turn_dir = turn[dir]
  turn_step = move(c, turn_dir)
  if map[turn_step.to_s].nil?
    # if a left turn is open, take it
    dir = turn_dir
    c = turn_step
  else
    # maintain old direction and move
    c = move(c, dir)
  end

  # increment counter

  if PART_ONE
    n += 1
  else
    n = sum_of_neighbors(map, c)
  end

  # puts "COORDS #{ c.to_s } VAL #{n}"

  # store at current coordinate
  map[c.to_s] = n

  if PART_ONE
    if n === input
      puts "COORDS AT #{input}: #{c.to_s}"
      break
    end
  else
    if n > input
      puts "COORDS AT #{n} (> #{ input }): #{c.to_s}"
      break
    end
  end
end

puts "STEPS: #{ c[0].abs + c[1].abs }"
