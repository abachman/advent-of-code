# Due to the local geology, trees in this area only grow on exact integer
# coordinates in a grid. You make a map (your puzzle input) of the open squares
# (.) and trees (#) you can see. For example:
#
#   ..##.......
#   #...#...#..
#   .#....#..#.
#   ..#.#...#.#
#   .#...##..#.
#   ..#.##.....
#   .#.#.#....#
#   .#........#
#   #.##...#...
#   #...##....#
#   .#..#...#.#
#
# These aren't the only trees, though; due to something you read about once
# involving arboreal genetics and biome stability, the same pattern repeats to
# the right many times:
#
#   ..##.........##.........##.........##.........##.........##.......  --->
#   #...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
#   .#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
#   ..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
#   .#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
#   ..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....  --->
#   .#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
#   .#........#.#........#.#........#.#........#.#........#.#........#
#   #.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
#   #...##....##...##....##...##....##...##....##...##....##...##....#
#   .#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
#
# You start on the open square (.) in the top-left corner and need to reach the
# bottom (below the bottom-most row on your map).
#
# The toboggan can only follow a few specific slopes (you opted for a cheaper
# model that prefers rational numbers); start by counting all the trees you
# would encounter for the slope right 3, down 1:
#
# From your starting position at the top-left, check the position that is right
# 3 and down 1. Then, check the position that is right 3 and down 1 from there,
# and so on until you go past the bottom of the map.
#
# The locations you'd check in the above example are marked here with O where
# there was an open square and X where there was a tree:
#
#   ..##.........##.........##.........##.........##.........##.......  --->
#   #..O#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
#   .#....X..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
#   ..#.#...#O#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
#   .#...##..#..X...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
#   ..#.##.......#.X#.......#.##.......#.##.......#.##.......#.##.....  --->
#   .#.#.#....#.#.#.#.O..#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
#   .#........#.#........X.#........#.#........#.#........#.#........#
#   #.##...#...#.##...#...#.X#...#...#.##...#...#.##...#...#.##...#...
#   #...##....##...##....##...#X....##...##....##...##....##...##....#
#   .#..#...#.#.#..#...#.#.#..#...X.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
#
# In this example, traversing the map using this slope would cause you to
# encounter 7 trees.
#
# Starting at the top-left corner of your map and following a slope of right 3
# and down 1, how many trees would you encounter?

data = File.readlines('input.txt').map(&:chomp)

## data = %[..##.........##.........##.........##.........##.........##.......
## #...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
## .#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
## ..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
## .#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
## ..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....
## .#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
## .#........#.#........#.#........#.#........#.#........#.#........#
## #.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
## #...##....##...##....##...##....##...##....##...##....##...##....#
## .#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#].split("\n").map(&:chomp)

# NOTES:
# . open
# # tree
# pattern repeats to the right
# right 3, down 1
# count every tree (#) you land on


# assume every row in the map is the same length
x = 0
y = 0
c = 0

def move(data, x, y, r, d)
  return [
    (x + r) % data[y].size,
    y + d
  ]
end

# PART 1
while y < (data.size - 1)
  # move
  x, y = move(data, x, y, 3, 1)

  puts "MOVE TO #{x}, #{y} FOUND #{data[y][x]}"

  unless data[y].nil?
    c += data[y][x] === '#' ? 1 : 0
  end
end
puts "PART 1 TREES: #{c}"
puts "------------------"
#
#exit 0

# PART 2

slopes =[
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2],
]

slope_results = []

slopes.each do |slope|
  r, l = slope
  x = 0
  y = 0
  c = 0

  while y < (data.size - 1)
    # move
    x, y = move(data, x, y, r, l)

    unless data[y].nil?
      c += data[y][x] === '#' ? 1 : 0
    end
  end

  puts "#{slope.inspect} ENCOUNTERED #{c} TREES"
  slope_results << c
end

puts "MULT #{slope_results.inject(1, &:*)}"
