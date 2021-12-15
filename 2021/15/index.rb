# https://adventofcode.com/2021/day/15
# --- Day 15: Chiton ---
require 'set'

require_relative './priority_queue'
require_relative './element'

input = File.open('input.txt').readlines.map {|l| l.strip.split('').map(&:to_i) }

TIMES = 100
TRACE = true
PART_ONE = true

def trace(*msg)
  if TRACE || ENV['TRACE'] == '1'
    puts format(*msg.map {|f| %w(Array Hash Set).include?(f.class.to_s) ? f.inspect : f})
  end
end

# bold zero
def boldish(n, yes=false)
  yes ?
    "\e[31;1m#{n}\e[0m" :
    n.to_s
end

# input is a grid, route is a Hash of coords
def see(grid, route={})
  pattern = []
  score = 0
  grid.each_with_index do |line, y|
    row = ""

    line.each_with_index do |n, x|
      point = [x, y]
      yes = route[point]
      if yes
        score += weight(grid, point)
      end
      row << boldish(n, yes)
    end

    pattern << row
  end

  [ pattern.join("\n"), score ]
end

def neighbors(point)
  x, y = point
  [
    [0, -1], # don't go up?
    [-1, 0], # left
    [1, 0],  # right
    [0, 1]   # down
  ].map do |(dx, dy)|
    next if y + dy < 0 || x + dx < 0 # off top, left
    yield [x + dx, y + dy]
  end
end

def weight(graph, point)
  graph[point[1]][point[0]]
end

def in?(graph, point)
  return false if point[0] < 0 || point[1] < 0
  y = graph[point[1]]
  !(y.nil? || y[point[0]].nil?)
end

def walk(graph, origin, dest)
  # Ruby conversion of the pseudocode in https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm

  # distance from origin to given point
  dist = {}

  # paths to points
  prev = {}

  # nodes to visit
  unvisited = Set.new

  h = graph.size
  w = graph[0].size
  h.times do |y|
    w.times do |x|
      point = [x, y]
      next unless in?(graph, point)

      dist[point] = Float::INFINITY
      prev[point] = []

      unvisited.add(point)
    end
  end

  dist[origin] = 0
  measured = PriorityQueue.new
  measured << Element.new(origin, 0)

  while unvisited.size > 0
    # u ← vertex in Q with min dist[u]
    to_visit = measured.pop.value

    # remove u from Q
    unvisited.delete(to_visit)

    if to_visit == dest
      trace '<<<<<<< DEST %s >>>>>>>>', dest
      break
    end

    neighbors(to_visit) do |point|
      next unless unvisited.include?(point)

      # for each neighbor v of u still in Q:
      #   alt ← dist[u] + length(u, v)
      alt = dist[to_visit] + weight(graph, point)

      # if alt < dist[v]:
      if alt < dist[point]
        if dist[point] == Float::INFINITY
          measured << Element.new(point, alt)
        else
          measured.upsert(Element.new(point, alt))
        end

        dist[point] = alt
        prev[point] = to_visit
      end
    end

    # exit 0
  end

  # trace "prevs: %s", prev.keys

  # backtrack from finish to start
  path = []
  u = dest
  if prev[u] || u == origin
    while u && !u.empty?
      # trace '  path.unshift(%s)', u
      path.unshift(u)
      u = prev[u]
    end
  end

  # trace "path: %s", path
  path
end

if PART_ONE
  h = input.size
  w = input[0].size
  path = walk(input, [0, 0], [w - 1, h - 1])

  route, score = see(input, Hash[ path.map {|p| [p, true]} ])
  score -= weight(input, [0, 0])
  puts "ROUTE"
  puts route
  puts
  puts "SCORE: #{score}"
else
  # part two, the entire cave is actually five times larger in both dimensions than you thought
  wrapped = [1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6]

  trace 'before'
  trace see(input, {})[0]

  # right wards first
  ni = []
  input.each do |row|
    nr = []

    # regular
    row.each do |v|
      nr << v
    end

    # trace 'expand %s', row
    4.times do |n|
      up = n + 1
      row.each do |v|
        nv = v + up
        # trace '%i + %i -> %i', v, up, wrapped[nv]
        nr << wrapped[nv]
      end
    end

    ni << nr
  end

  input = ni
  ni = []

  # now we can go down
  5.times do |up|
    input.each do |row|
      ni << row.map {|v| wrapped[v + up]}
    end
  end

  input = ni

  h = input.size
  w = input[0].size
  path = walk(input, [0, 0], [w - 1, h - 1])
  route, score = see(input, Hash[ path.map {|p| [p, true]} ])
  score -= weight(input, [0, 0])
  puts "ROUTE"
  puts route
  puts
  puts "SCORE: #{score}"
end
