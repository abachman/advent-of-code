# --- Day 13: A Maze of Twisty Little Cubicles ---
#
# You arrive at the first floor of this new building to discover a much less
# welcoming environment than the shiny atrium of the last one. Instead, you are
# in a maze of twisty little cubicles, all alike.
#
# Every location in this area is addressed by a pair of non-negative integers
# (x,y). Each such coordinate is either a wall or an open space. You can't move
# diagonally. The cube maze starts at 0,0 and seems to extend infinitely toward
# positive x and y; negative values are invalid, as they represent a location
# outside the building. You are in a small waiting area at 1,1.
#
# While it seems chaotic, a nearby morale-boosting poster explains, the layout
# is actually quite logical. You can determine whether a given x,y coordinate
# will be a wall or an open space using a simple system:
#
# - Find x*x + 3*x + 2*x*y + y + y*y.
# - Add the office designer's favorite number (your puzzle input).
# - Find the binary representation of that sum; count the number of bits that
#   are 1.
#   - If the number of bits that are 1 is even, it's an open space.
#   - If the number of bits that are 1 is odd, it's a wall.
#
# For example, if the office designer's favorite number were 10, drawing walls
# as # and open spaces as ., the corner of the building containing 0,0 would
# look like this:
#
#       0123456789
#     0 .#.####.##
#     1 ..#..#...#
#     2 #....##...
#     3 ###.#.###.
#     4 .##..#..#.
#     5 ..##....#.
#     6 #...##.###
#
# Now, suppose you wanted to reach 7,4. The shortest route you could take is
# marked as O:
#
#       0123456789
#     0 .#.####.##
#     1 .O#..#...#
#     2 #OOO.##...
#     3 ###O#.###.
#     4 .##OO#OO#.
#     5 ..##OOO.#.
#     6 #...##.###
#
# Thus, reaching 7,4 would take a minimum of 11 steps (starting from your
# current location, 1,1).
#
# What is the fewest number of steps required for you to reach 31,39?
#
# Your puzzle input is 1350.
#
require 'set'

PART_ONE = false

INPUT = 1350
FIND = [31, 39]
DISTANCE = 80

# INPUT = 10
# FIND = [7, 4]
# DISTANCE = 10

map = []

def hamming_weight(x)
  b = 0
  while x > 0
    x &= x - 1
    b += 1
  end
  return b
end

(0..FIND[1] + 10).each do |y|
  map << []
  row = map[y]
  (0..FIND[0] + 30).each do |x|
    check = x*x + 3*x + 2*x*y + y + y*y
    check += INPUT
    if hamming_weight(check) % 2 == 0
      row << '.'
    else
      row << '#'
    end
  end
end

# at least this many moves to get from node to goal
def estimate_cost(node, goal)
  return (goal[0] - node[0]).abs + (goal[1] - node[1]).abs
end

def reconstruct_path(came_from, start)
  current = start
  total_path = [start]
  while came_from[current]
    current = came_from[current]
    total_path << current
  end
  total_path
end

def neighbors(node, map)
  n = []

  [
    [0, -1], # above
    [1, 0],  # right
    [0, 1],  # below
    [-1, 0], # left
  ].each do |(x, y)|
    nx = node[0] + x
    ny = node[1] + y
    next if nx < 0 ||       # off x axis low
      ny < 0 ||             # off y axis low
      map[ny].nil? ||       # off y axis high
      map[ny][nx].nil? ||   # off x axis high
      map[ny][nx] === '#'   # is wall
    n << [node[0] + x, node[1] + y]
  end
  n
end

# A* Pathfinding Algorithm. Solves part 1. Thanks to:
# https://en.wikipedia.org/wiki/A*_search_algorithm
def a_star(start, goal, map)
  # Already evaluated
  visited_nodes = Set.new()

  # Nearby, need evaluating
  unvisited_nodes = Set.new([start])

  # `came_from` is a mapping where key is the node in question and value is the
  # node that we came from to get there. The solution to the shortest path
  # problem is following the came_from mapping backwards from goal to start.
  #
  # For example, the following values:
  #   start     => [0, 0]
  #   goal      => [1, 2],
  #   came_from => {
  #     [0, 0]: nil,
  #     [0, 1]: [0, 0],
  #     [1, 1]: [0, 1],
  #     [1, 2]: [1, 1]
  #   }
  #
  # Will produce the path: [ [1, 2], [1, 1], [0, 1], [0, 0] ]
  #
  came_from = {}
  map.size.times {|y| map[y].size.times {|x| came_from[ [x, y] ] = nil }}

  # `gScore` is a mapping of nodes to the minimum cost of getting from the
  # start node to that node. All nodes' cost is initialized to an arbitrarily
  # high amount.
  gScore = {}
  map.size.times {|y| map[y].size.times {|x| gScore[ [x, y] ] = 2**16 }}
  # Origin is 0, since we're already there.
  gScore[start] = 0

  # `fScore` is a mapping of nodes the total cost of getting from the start
  # node to the goal by passing that node. All nodes' cost is set to an
  # arbitrarily high amount.
  fScore = {}
  map.size.times {|y| map[y].size.times {|x| fScore[ [x, y] ] = 2**16 }}

  fScore[start] = estimate_cost(start, goal)

  while unvisited_nodes.size > 0
    # The next node to be visited should always be the unvisited node with the
    # lowest fScore
    current = unvisited_nodes.to_a.map {|node| [fScore[node], node]}.sort.first[1]

    if current == goal
      return reconstruct_path(came_from, current)
    end

    unvisited_nodes.delete(current)
    visited_nodes << current

    neighbors(current, map).each do |neighbor|
      # already seen
      next if visited_nodes.include?(neighbor)

      tentative_gScore = gScore[current] + 1
      if !unvisited_nodes.include?(neighbor)
        unvisited_nodes << neighbor
      elsif tentative_gScore >= gScore[neighbor]
        # worse path, don't update scores or came_from
        next
      end

      # current is the best way to get to neighbor
      came_from[neighbor] = current
      gScore[neighbor] = tentative_gScore
      # fScore is the least possible steps required to get to the goal
      fScore[neighbor] = gScore[neighbor] + estimate_cost(neighbor, goal)
    end
  end

  return nil
end

# Collect all nodes that can be reached by starting at `start` and walking
# `dist` on `map`. Solves part 2.
def walk_to_distance(start, dist, map)
  visited_nodes = Set.new([start])
  current_round = neighbors(start, map)

  solution = []

  # steps taken
  steps = 0

  while steps < dist
    next_round = []

    current_round.each do |current|
      neighbors(current, map).each do |neighbor|
        if !visited_nodes.include?(neighbor)
          next_round << neighbor
        end
      end
      visited_nodes << current
    end

    current_round = next_round

    steps += 1
  end

  visited_nodes.to_a
end

if PART_ONE
  solution = a_star([1,1], FIND, map)
else
  solution = walk_to_distance([1, 1], DISTANCE, map)
end

headers = []
3.times do |hidx|
  headers << []
  hrow = headers[hidx]

  (0..(map[0].size - 1)).each do |col|
    colstr = "%3i" % col
    hrow << colstr[hidx]
  end
end

headers.each do |hdr|
  puts "     #{ hdr.join('') }"
end

map.each_with_index do |row, y|
  print " %3i " % [y]
  row.each_with_index do |char, x|
    if solution && solution.include?([x, y])
      print 'O'
    else
      print char
    end
  end
  print "\n"
end

puts
if PART_ONE
  puts "SOLUTION LENGTH: #{ solution.size - 1 }" # solution path is moves, nodes - 1 since start
else
  puts "SOLUTION LENGTH: #{ solution.size }" # solution is unique visited nodes
end
puts
