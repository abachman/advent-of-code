PART_ONE = true

infile = <<EOS
30373
25512
65332
33549
35390
EOS

infile = File.open('input.txt').read

grid = infile.lines.map {|l| l.chomp.split('').map(&:to_i) }

# associate each grid value with its original coordinate and an empty array for scenic score
grid.each_with_index do |row, ridx|
  row.each_with_index do |cval, cidx|
    grid[ridx][cidx] = [cval, "#{ridx},#{cidx}", []]
  end
end

# First, determine whether there is enough tree cover here to keep a tree house
# hidden. To do this, you need to count the number of trees that are visible
# from outside the grid when looking directly along a row or column.

# 1. all edge trees are visible (width * 2 + (height - 2) * 2) `(row[0][0].size * 2) + (row[0].size - 2) * 2`
# 2. consider one direction at a time, then rotate the grid and reconsider
# 3. only count each tree once. e.g., if it's visible from N and W, it's still only 1 tree

# PART TWO ----
#
# To measure the viewing distance from a given tree, look up, down, left, and
# right from that tree; stop if you reach an edge or at the first tree that is
# the same height or taller than the tree under consideration. (If a tree is
# right on the edge, at least one of its viewing distances will be zero.)
#
prod = lambda { |l| l.reduce(1) { |memo, obj| memo * obj } }

def visible(g, seen)
  # check visibility from top downwards
  maxes = g[0].dup.map(&:first)
  g[0].size.times do |cidx|
    next if cidx == 0 || cidx == g[0].size - 1 # skip edges

    ridx = 1
    while ridx < g.size - 1 do
      val, key, scores = g[ridx][cidx]

      if val > maxes[cidx]
        # PART ONE next most visible tree
        maxes[cidx] = val
        puts "DUP #{key}" if seen[key]
        seen[key] = true
      end

      ridx += 1
    end
  end
end

seen = {}
visible(grid, seen)
# rot 1
rot = grid.transpose.map(&:reverse)
visible(rot, seen)
# rot 2
rot = rot.transpose.map(&:reverse)
visible(rot, seen)
# rot 3
rot = rot.transpose.map(&:reverse)
visible(rot, seen)

count = grid.size * 2 + (grid[0].size - 2) * 2 + seen.keys.size

puts "SEEN: #{seen}"
puts "VISIBLE: #{count}"


