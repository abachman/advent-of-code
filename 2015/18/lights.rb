# --- Day 18: Like a GIF For Your Yard ---
#
# After the million lights incident, the fire code has gotten stricter: now, at
# most ten thousand lights are allowed. You arrange them in a 100x100 grid.
#
# Never one to let you down, Santa again mails you instructions on the ideal
# lighting configuration. With so few lights, he says, you'll have to resort to
# animation.
#
# Start by setting your lights to the included initial configuration (your
# puzzle input). A # means "on", and a . means "off".
#
# Then, animate your grid in steps, where each step decides the next
# configuration based on the current one. Each light's next state (either on or
# off) depends on its current state and the current states of the eight lights
# adjacent to it (including diagonals). Lights on the edge of the grid might
# have fewer than eight neighbors; the missing ones always count as "off".
#
# For example, in a simplified 6x6 grid, the light marked A has the neighbors
# numbered 1 through 8, and the light marked B, which is on an edge, only has
# the neighbors marked 1 through 5:
#
#   1B5...
#   234...
#   ......
#   ..123.
#   ..8A4.
#   ..765.
#
# The state a light should have next is based on its current state (on or off)
# plus the number of neighbors that are on:
#
# - A light which is on stays on when 2 or 3 neighbors are on, and turns off
#   otherwise.
# - A light which is off turns on if exactly 3 neighbors are on, and stays off
#   otherwise.
# - All of the lights update simultaneously; they all consider the same current
#   state before moving to the next.
#
# Here's a few steps from an example configuration of another 6x6 grid:
#
# Initial state:
#
#   .#.#.#
#   ...##.
#   #....#
#   ..#...
#   #.#..#
#   ####..
#
# After 1 step:
#
#   ..##..
#   ..##.#
#   ...##.
#   ......
#   #.....
#   #.##..
#
# After 2 steps:
#
#   ..###.
#   ......
#   ..###.
#   ......
#   .#....
#   .#....
#
# After 3 steps:
#
#   ...#..
#   ......
#   ...#..
#   ..##..
#   ......
#   ......
#
# After 4 steps:
#
#   ......
#   ......
#   ..##..
#   ..##..
#   ......
#   ......
#
# After 4 steps, this example has four lights on.
#
# In your grid of 100x100 lights, given your initial configuration, how many
# lights are on after 100 steps?
#
# --- Part Two ---
#
# You flip the instructions over; Santa goes on to point out that this is all
# just an implementation of Conway's Game of Life. At least, it was, until you
# notice that something's wrong with the grid of lights you bought: four
# lights, one in each corner, are stuck on and can't be turned off. The example
# above will actually run like this:
#
#  ...
#
# After 5 steps, this example now has 17 lights on.
#
# In your grid of 100x100 lights, given your initial configuration, but with
# the four corners always in the on state, how many lights are on after 100
# steps?
#

## From Ruby DCamp 2015

require 'set'
require 'io/console'

RULES = [
  [true, 2],
  [true, 3],
  [false, 3],
]

# Message passing, down the pile
class World
  def initialize(cells=nil)
    @cells = cells || Set.new

    # FOUR CORNERS RULE:
    add_coord(0, 0)
    add_coord(0, GRID-1)
    add_coord(GRID-1, 0)
    add_coord(GRID-1, GRID-1)
  end

  def add_cell(cell)
    @cells.add cell
  end

  def add_coord(x, y)
    @cells.add Cell.at(x, y)
  end

  def candidates
    Set.new(cells.map {|c| c.neighbors.to_a}.flatten)
  end

  def neighbor_count(cell)
    # add 1 for every neighbor that is already a member of @cells
    cell.neighbors.inject(0) {|memo, obj|
      (obj != cell && @cells.include?(obj)) ? memo + 1 : memo
    }
  end

  def step
    # add candidates that survive or are born to the next round
    World.new(Set.new(candidates.select do |cell|
      RULES.include?([@cells.include?(cell), neighbor_count(cell)])
    end))
  end

  def cells
    @cells
  end

  def ==(other)
    @cells == other.cells
  end

  def to_s
    @cells.inspect
  end
end

# make sure we have the cartesian set of [1, -1, 0] and [1, -1, 0]
OFFSETS = Set.new([1, 1, 0, 0, -1, -1].permutation(2).map {|c| c})
CELL_LIBRARY = {}

class Cell
  attr_reader :x, :y

  # only ever allocate one instance of Cell at a given x, y
  def self.at(x, y)
    # 2**x * 3**y is safe as a key function since it is guaranteed to produce a
    # unique value for each pair of given x, y
    #
    # https://en.wikipedia.org/wiki/Fundamental_theorem_of_arithmetic
    CELL_LIBRARY[2 ** x * 3 ** y] ||= new(x, y)
  end

  def initialize(x, y)
    @x = x
    @y = y
  end

  def coordinates
    @coordinates ||= [@x, @y]
  end

  def neighbors
    # DO NOT CONSIDER NEIGHBORS OUTSIDE GRID
    @neighbors ||= Set.new(OFFSETS.map {|(x, y)|
      nx = x + @x
      ny = y + @y

      # only add cells inside GRID x GRID grid world
      if nx >= 0 && nx < GRID && ny >= 0 && ny < GRID
        Cell.at(x + @x, y + @y)
      end
    }.compact)
  end

  def ==(other)
    self.coordinates == other.coordinates
  end

  def eql?(other)
    self == other
  end

  def hash
    coordinates.hash
  end
end

# render the active world within the terminal
class Renderer
  def initialize(width, height)
    min_x, max_x = 0, width
    min_y, max_y = 0, height

    @x_range = (min_x..max_x)
    @y_range = (min_y..max_y)
  end

  def draw(world)
    page = ""
    @y_range.each do |y|
      line = "  "
      @x_range.each do |x|
        line += world.cells.include?(Cell.at(x, y)) ? '#' : '.' # '💩' : ' '
      end
      page += line
      page += "\n"
    end
    puts page
    puts
  end
end

### now the solution

TEST = false

if TEST
  in_file = %w(.#.#.#
  ...##.
  #....#
  ..#...
  #.#..#
  ####..
  )
  GRID = 6
else
  in_file = open('input.txt').readlines
  GRID = 100
end

world = World.new

in_file.each_with_index do |line, y|
  line.each_char.each_with_index do |char, x|
    if /#/ =~ char
      world.add_coord(x, y)
    end
  end
  # puts "LINE #{ y } SIZE #{ line.size }"
end

puts "initial living: #{ world.cells.size }"

if TEST
  renderer = Renderer.new(5, 5)
  6.times do
    renderer.draw(world)
    world = world.step
    sleep 0.1
  end
else
  100.times do
    world = world.step
  end
end

puts "FINAL LIVING: #{ world.cells.size }"


# count living cells inside (0,0) (99, 99)
