# http://adventofcode.com/2016/day/1
#
# --- Day 1: No Time for a Taxicab ---
#
# You're airdropped near Easter Bunny Headquarters in a city somewhere. "Near",
# unfortunately, is as close as you can get - the instructions on the Easter
# Bunny Recruiting Document the Elves intercepted start here, and nobody had time
# to work them out further.
#
# The Document indicates that you should start at the given coordinates (where
# you just landed) and face North. Then, follow the provided sequence: either
# turn left (L) or right (R) 90 degrees, then walk forward the given number of
# blocks, ending at a new intersection.
#
# There's no time to follow such ridiculous instructions on foot, though, so you
# take a moment and work out the destination. Given that you can only walk on the
# street grid of the city, how far is the shortest path to the destination?
#
# For example:
#
# - Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks
#   away.
# - R2, R2, R2 leaves you 2 blocks due South of your starting position, which
#   is 2 blocks away.
# - R5, L5, R5, R3 leaves you 12 blocks away.
#
# How many blocks away is Easter Bunny HQ?
#
# --- Part Two ---
#
# Then, you notice the instructions continue on the back of the Recruiting
# Document. Easter Bunny HQ is actually at the first location you visit twice.
#
# For example, if your instructions are R8, R4, R4, R8, the first location you
# visit twice is 4 blocks away, due East.
#
# How many blocks away is the first location you visit twice?
#

def move(dir, orient, loc)
  # change orientation and location in response to given direction in [ TURN, MOVE ] form
  turn, distance = dir

  # update orientation
  orient = turn === 'R' ? (orient + 1) % 4 : (orient - 1) % 4

  # move to new location
  nloc = case orient
         when 0
           [ loc[0], loc[1] + distance ]
         when 1
           [ loc[0] + distance, loc[1] ]
         when 2
           [ loc[0], loc[1] - distance ]
         when 3
           [ loc[0] - distance, loc[1] ]
         end

  [ orient, nloc ]
end

def log(msg)
  ## uncomment to show debugging messages
  # puts msg
end

PART_TWO = true
INPUT = open('input.txt').read().split(',').map(&:strip)

directions = INPUT.map do |d|
  [ d[0], d[1..-1].to_i ]
end

orientation = 0 # N
location = [0, 0] # lat, lon
visits = {}

# line from origin to point on an integer grid, assumes one coord is 0
def grid_line(point)
  if point[0] != 0
    sign = point[0] < 0 ? -1 : 1
    (1..point[0].abs).map do |x|
      [ x * sign, 0 ]
    end
  else
    sign = point[1] < 0 ? -1 : 1
    (1..point[1].abs).map do |y|
      [ 0, y * sign ]
    end
  end
end

# return all points between ( start_at and end_at ]
def points_between(start_at, end_at)
  grid_line(
    # start_at [0, 0] + end_at [0, -1] = [0, -1]
    end_at.zip(start_at).map {|(a, b)| a - b}
  ).map do |( x, y )|
    [ start_at[0] + x, start_at[1] + y ]
  end
end

directions.each do |d|

  before_location = location.dup
  orientation, location = move(d, orientation, location)

  if PART_TWO
    # PART 2 - mark all "blocks" between before and current locations as visited
    path = points_between(before_location, location)

    log "  MOVED #{ d[1] } #{ 'NESW'[orientation] } FROM #{ before_location.inspect } TO #{ location }"

    revisit = nil
    (path).each do |l|
      if visits.key?(l)
        revisit = l
        break
      end
      visits[l] = true
    end

    if revisit
      log "  SECOND VISIT TO #{ revisit } IN #{ visits.size } MOVES"
      location = revisit
      break
    end

    log "--"
  end
end

puts
puts "^^^^^^^^^^"
puts "FINAL ORIENTATION    #{ 'NESW'[orientation] }"
puts "FINAL LOCATION       #{ location.inspect }"
puts "DISTANCE FROM ORIGIN #{ location.map(&:abs).inject(0) {|a, o| a + o} }"
puts "^^^^^^^^^^"
puts

# PART 1: 278
# PART 2: 161
