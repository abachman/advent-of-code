# --- Day 14: Disk Defragmentation ---

require_relative '../10/source.rb'

input = 'amgozmfv' # mine
# input = 'flqrgnkx' # example

PART_ONE = ENV['TWO'] != '1'

def hash_to_binary(hex)
  hex.each_char.inject('') {|memo, obj|
    memo << "%04b" % [obj.to_i(16)]
  }
end

# puts hash_to_binary 'a0c2017'
# given
# -> 10100000110000100000000101110000
# calculated
# -> 1010000011000010000000010111

NEIGHBOR_OFFSETS = [
  # col, row
  [-1, 0],
  [0, -1],
  [+1, 0],
  [0, +1]
]

# only return directly adjacent neighbors
def find_neighbors(origin)
  NEIGHBOR_OFFSETS.each do |offset|
    neighbor = [origin[0] + offset[0], origin[1] + offset[1]]

    if  (neighbor[0] > -1 && neighbor[0] < 128) &&
        (neighbor[1] > -1 && neighbor[1] < 128)
      yield neighbor
    end
  end
end

# starting at a cell, visit adjacent marked cells until there are no remaining
# marked neighbors. return list of visited cells
def find_region(map, origin, seen)
  to_visit = [ origin ]
  count = 0

  seen[origin] = true

  while (origin = to_visit.shift)
    count += 1
    find_neighbors(origin) do |neighbor|
      next if seen[neighbor]

      # if neighbor is marked, find its neighbors
      #      row          col
      if map[neighbor[1]][neighbor[0]] === '1'
        # puts "    # FOUND"
        to_visit << neighbor
      end

      seen[neighbor] = true
    end
  end

  return count
end

def increment(origin)
  if origin[0] + 1 > 127
    if origin[1] + 1 < 128
      # next row
      [ 0, origin[1] + 1 ]
    else
      # end of map
      [ 128, 128 ]
    end
  else
    # same row, next cell
    [ origin[0] + 1, origin[1] ]
  end
end

def count_regions(map)
  origin = [0, 0]
  seen = {}

  region_count = 0
  marked_count = 0

  while origin[0] < 128 && origin[1] < 128
    if seen[origin]
      origin = increment(origin)
      next
    end

    # if point is marked, find the region
    if map[origin[1]][origin[0]] === '1'
      print '.'

      count = find_region(map, origin, seen)

      region_count += 1
      marked_count += count
    else
      seen[origin] = true
    end

    origin = increment(origin)
  end

  puts "DONE"
  puts
  puts "  REGIONS: #{region_count}"
  puts "  MARKED:  #{marked_count}"
  puts "  VISITED: #{seen.size} OF #{ 128 * 128 }"
  puts
end

map = []
128.times do |n|
  row_input = "#{input}-#{n}"
  map << hash_to_binary(knot_hash(row_input))
  # .gsub('1', '#').gsub('0', '.')
end

if PART_ONE
  puts map.join("\n")
  p1_count = map.map{|r| r.count('1')}.sum
  puts "PART 1 COUNT: #{p1_count}"
else
  count_regions(map)
end


