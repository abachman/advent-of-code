# http://adventofcode.com/2017/day/12
#

input = open('input.txt').readlines()

# input = '0 <-> 2
# 1 <-> 1
# 2 <-> 0, 3, 4
# 3 <-> 2, 4
# 4 <-> 2, 3, 6
# 5 <-> 6
# 6 <-> 4, 5'.split("\n")

# store layout as node -> edge list
edges = {}

input.each do |line|
  node, connections = line.split('<->').map(&:strip)
  connections = connections.split(',').map(&:strip)

  edges[node] ||= []
  connections.each do |conn|
    edges[node] = (edges[node] + [conn]).uniq

    edges[conn] ||= []
    edges[conn] = (edges[conn] + [node]).uniq
  end
end

def show_edges(edges)
  puts "EDGES"
  edges.keys.each do |node|
    puts "#{node} -> #{ edges[node].inspect }"
  end
end

def tree(graph, node, seen=[], level=0)
  if !seen.include?(node)
    seen << node
    graph[node].each do |edge|
      tree(graph, edge, seen, level + 1)
    end
  end
  return seen
end

seen = tree(edges, '0')

# after one pass, seen contains every node that has a connection to '0'
puts "PART ONE ANSWER: #{seen.size}"

# For part 2, we want to know how many networks the input contains. To do that
# we can grab the next key from `edges` that hasn't already been visited and
# walk its tree. We then repeat until all nodes have been visited.

visited = []
graphs = 1 # one group has already been found

seen.each {|node| visited << node}
next_node = (edges.keys - visited)[0]

while next_node
  graphs += 1
  seen = tree(edges, next_node)
  seen.each {|node| visited << node}
  next_node = (edges.keys - visited)[0]
end

puts "PART TWO ANSWER: #{graphs}"
