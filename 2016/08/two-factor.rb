# --- Day 8: Two-Factor Authentication ---
#
# You come across a door implementing what you can only assume is an
# implementation of two-factor authentication after a long game of requirements
# telephone.
#
# To get past the door, you first swipe a keycard (no problem; there was one on
# a nearby desk). Then, it displays a code on a little screen, and you type
# that code on a keypad. Then, presumably, the door unlocks.
#
# Unfortunately, the screen has been smashed. After a few minutes, you've taken
# everything apart and figured out how it works. Now you just have to work out
# what the screen would have displayed.
#
# The magnetic strip on the card you swiped encodes a series of instructions
# for the screen; these instructions are your puzzle input. The screen is 50
# pixels wide and 6 pixels tall, all of which start off, and is capable of
# three somewhat peculiar operations:
#
# - rect AxB turns on all of the pixels in a rectangle at the top-left of the
#   screen which is A wide and B tall.
# - rotate row y=A by B shifts all of the pixels in row A (0 is the top row)
#   right by B pixels. Pixels that would fall off the right end appear at the
#   left end of the row.
# - rotate column x=A by B shifts all of the pixels in column A (0 is the left
#   column) down by B pixels. Pixels that would fall off the bottom appear at the
#   top of the column.
#
# For example, here is a simple sequence on a smaller screen:
#
# - rect 3x2 creates a small rectangle in the top-left corner:
#
#   ###....
#   ###....
#   .......
#
# - rotate column x=1 by 1 rotates the second column down by one pixel:
#
#   #.#....
#   ###....
#   .#.....
#
# - rotate row y=0 by 4 rotates the top row right by four pixels:
#
#   ....#.#
#   ###....
#   .#.....
#
# - rotate column x=1 by 1 again rotates the second column down by one pixel,
#   causing the bottom pixel to wrap back to the top:
#
#   .#..#.#
#   #.#....
#   .#.....
#
# As you can see, this display technology is extremely powerful, and will soon
# dominate the tiny-code-displaying-screen market. That's what the
# advertisement on the back of the display tries to convince you, anyway.
#
# There seems to be an intermediate check of the voltage used by the display:
# after you swipe your card, if the screen did work, how many pixels should be
# lit?
#
# --- Part Two ---
#
# You notice that the screen is only capable of displaying capital letters; in
# the font it uses, each letter is 5 pixels wide and 6 tall.
#
# After you swipe your card, what code is the screen trying to display?
#

def create(width, height)
  (0..(height - 1)).inject([]) {|memo, idx|
    memo << ([0] * width)
    memo
  }
end

def draw(screen)
  count = 0
  screen.each do |row|
    puts row.map {|p|
      if p == 1
        count += 1
        '#'
      else
        '.'
      end
    }.join('')
  end
  puts "CELL COUNT #{ count }"
  puts
end

def rect(screen, width, height)
  (0..(height - 1)).each do |y|
    (0..(width - 1)).each do |x|
      screen[y][x] = 1
    end
  end
end

def rotate_col(screen, col, dist)
  height = screen.size

  # get next col without changing screen
  next_col = []
  height.times do |idx|
    next_col << screen[((idx - dist) % height)][col]
  end

  # apply change to screen
  height.times do |idx|
    screen[idx][col] = next_col[idx]
  end
end

def rotate_row(screen, row, dist)
  width = screen[row].size

  next_row = []
  width.times do |idx|
    next_row << screen[row][((idx - dist) % width)]
  end

  # apply changes
  width.times do |idx|
    screen[row][idx] = next_row[idx]
  end
end

# real input
screen = create(50, 6)
# screen = create(7, 3)

# INPUT = %[
# rect 3x2
# rotate column x=1 by 1
# rotate row y=0 by 4
# rotate column x=1 by 1
# ].split("\n").map(&:strip).reject {|l| l == ''}
INPUT = open('input.txt').readlines().map(&:strip)

INPUT.each do |instruction|
  if /rect (\d+)x(\d+)/ =~ instruction
    width = $1.to_i
    height = $2.to_i
    puts "RECT #{ width.inspect } #{ height.inspect }"
    rect(screen, width, height)
  elsif /rotate column x=(\d+) by (\d+)/ =~ instruction
    col = $1.to_i
    distance = $2.to_i
    puts "ROTATE COLUMN #{ col.inspect } #{ distance.inspect }"
    rotate_col(screen, col, distance)
  elsif /rotate row y=(\d+) by (\d+)/ =~ instruction
    row = $1.to_i
    distance = $2.to_i
    puts "ROTATE ROW #{ row.inspect } #{ distance.inspect }"
    rotate_row(screen, row, distance)
  else
    raise "UNRECOGNIZED INSTRUCTION: #{ instruction }"
  end
end

draw(screen)

# PART 1: 116
#
# PART 2: UPOJFLBCEZ
#
#    #..#.###...##....##.####.#....###...##..####.####.
#    #..#.#..#.#..#....#.#....#....#..#.#..#.#.......#.
#    #..#.#..#.#..#....#.###..#....###..#....###....#..
#    #..#.###..#..#....#.#....#....#..#.#....#.....#...
#    #..#.#....#..#.#..#.#....#....#..#.#..#.#....#....
#    .##..#.....##...##..#....####.###...##..####.####.
#
