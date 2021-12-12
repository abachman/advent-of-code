# --- Day 12: Passage Pathing ---
# https://adventofcode.com/2021/day/12
#
# PART_ONE
#
# Your goal is to find the number of distinct paths that start at start, end at
# end, and don't visit small caves more than once. There are two types of caves:
# big caves (written in uppercase, like A) and small caves (written in
# lowercase, like b). It would be a waste of time to visit any small cave more
# than once, but big caves are large enough that it might be worth visiting them
# multiple times. So, all paths you find should visit small caves at most once,
# and can visit big caves any number of times.
#
# --- PART_TWO ---
#
# After reviewing the available paths, you realize you might have time to visit
# a single small cave twice. Specifically, big caves can be visited any number
# of times, a single small cave can be visited at most twice, and the remaining
# small caves can be visited at most once. However, the caves named start and
# end can only be visited exactly once each: once you leave the start cave, you
# may not return to it, and once you reach the end cave, the path must end
# immediately.

require 'set'

input = File.open('input.txt').readlines.map {|l| l.strip }

TRACE = false
PART_ONE = false
PART_TWO = true

def trace(*msg)
  if TRACE || ENV['TRACE'] == '1'
    puts format(*msg)
  end
end

IS_SMOL = {}
def smol?(cave)
  /^[a-z]+$/ =~ cave
end

def to_dot(graph)
  rows = []

  graph.each do |(key, vals)|
    vals.each do |val|
      rows << [key, val]
    end
  end

  seen = {}
  File.open('graph.dot', 'w') do |f|
    f.write <<-OUT
      graph {
        #{
          rows.map do |(a, b)|
            next if seen[[a, b]]
            trace "%s -- %s", a, b
            seen[[b, a]] = true
            "#{a} -- #{b}\n"
          end.compact.join
        }
      }
    OUT
  end
end

def walk(point, graph, path: [], paths: [])
  trace 'walk(%s, path: %s)', point, path.inspect

  if point == 'end'
    trace '  found!'
    paths << path + [point]
    return
  end

  if PART_ONE
    return if smol?(point) && path.include?(point)
  elsif PART_TWO
    if smol?(point) && path.include?(point)
      # point may only be in path 1 time already
      return if path.count(point) > 1

      # there may be only one smol cave in path twice
      return if path[1..-1].filter { |cave|
        # there is any other smol cave in path > 1 time
        cave != point && smol?(cave)
      }.any? {|cave| path.count(cave) > 1 }
    end
  end

  # next_path = path + [point]

  graph[point].each do |step|
    trace '  %s -> %s', point, step

    # don't go back to start
    next if step == 'start'

    # don't return to little caves already included in the path
    walk(step, graph, path: path + [point], paths: paths)
  end

  paths
end

# remove subgraphs only reachable from cave
def prune(graph, cave)
end

def parse(lines)
  graph = {
  }

  lines.each do |line|
    a, b = line.split('-')
    if a == 'start'
      graph['start'] ||= Set[]
      graph['start'].add b
    elsif b == 'end'
      graph[a] ||= Set[]
      graph[a].add 'end'
    else
      graph[a] ||= Set[]
      graph[a].add b
      graph[b] ||= Set[]
      graph[b].add a
    end
  end

  graph
end

graph = parse(input)
trace graph.inspect
to_dot(graph)

# all paths starting at `point` ending at 'end'
paths = walk('start', graph)

# paths.each do |path|
#   puts path.join(',')
# end

puts "PATHS: #{paths.size}"