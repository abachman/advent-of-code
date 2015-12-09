# --- Day 9: All in a Single Night ---
#
# Every year, Santa manages to deliver all of his presents in a single night.
#
# This year, however, he has some new locations to visit; his elves have provided
# him the distances between every pair of locations. He can start and end at any
# two (different) locations he wants, but he must visit each location exactly
# once. What is the shortest distance he can travel to achieve this?
#
# For example, given the following distances:
#
# - London to Dublin = 464
# - London to Belfast = 518
# - Dublin to Belfast = 141
#
# The possible routes are therefore:
#
# - Dublin -> London -> Belfast = 982
# - London -> Dublin -> Belfast = 605
# - London -> Belfast -> Dublin = 659
# - Dublin -> Belfast -> London = 659
# - Belfast -> Dublin -> London = 605
# - Belfast -> London -> Dublin = 982
#
# The shortest of these is London -> Dublin -> Belfast = 605, and so the answer
# is 605 in this example.
#
# What is the distance of the shortest route?
#
# --- Part Two ---
#
# The next year, just to show off, Santa decides to take the route with the
# longest distance instead.
#
# He can still start and end at any two (different) locations he wants, and he
# still must visit each location exactly once.
#
# For example, given the distances above, the longest route would be 982 via (for
# example) Dublin -> London -> Belfast.
#
# What is the distance of the longest route?
#

require 'set'

cities = Set.new
connections = {}

# in_file = [
#   'London to Dublin = 464',
#   'London to Belfast = 518',
#   'Dublin to Belfast = 141',
# ]

in_file = open('input.txt').readlines

def parse(line)
  if /([A-Za-z]+) to ([A-Za-z]+) = (\d+)/ =~ line
    [$1, $2, $3.to_i]
  else
    raise "SYNTAX ERROR: `#{ line }`"
  end
end

def path_id(a, b)
  [a, b].sort
end

in_file.each do |line|
  from, to, dist = parse(line.strip)

  cities.add from
  cities.add to

  connections[path_id(from, to)] = dist
end

routes = []
cities.to_a.permutation.each do |option|
  has_path = true
  prev = nil
  path = []
  distance = 0
  option.each do |city|
    path << city
    if prev == nil
      prev = city
      next
    end

    if dist = connections[path_id(prev, city)]
      distance += dist
    else
      has_path = false
      break
    end

    prev = city
  end

  if has_path
    routes << [distance, path]
  end
end

routes = routes.sort
shortest = routes.first
longest = routes.last

puts "#{ cities.size } nodes"
puts "#{ connections.size } edges"
puts "Shortest path: #{ shortest[1].join(' -> ') } = #{ shortest[0] }"
puts "Longest  path: #{ longest[1].join(' -> ') } = #{ longest[0] }"
