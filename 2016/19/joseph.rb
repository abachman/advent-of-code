# --- Day 19: An Elephant Named Joseph ---
#
# The Elves contact you over a highly secure emergency channel. Back at the
# North Pole, the Elves are busy misunderstanding White Elephant parties.
#
# Each Elf brings a present. They all sit in a circle, numbered starting with
# position 1. Then, starting with the first Elf, they take turns stealing all
# the presents from the Elf to their left. An Elf with no presents is removed
# from the circle and does not take turns.
#
# For example, with five Elves (numbered 1 to 5):
#
#        1
#      5   2
#       4 3
#
# - Elf 1 takes Elf 2's present.
# - Elf 2 has no presents and is skipped.
# - Elf 3 takes Elf 4's present.
# - Elf 4 has no presents and is also skipped.
# - Elf 5 takes Elf 1's two presents.
# - Neither Elf 1 nor Elf 2 have any presents, so both are skipped.
# - Elf 3 takes Elf 5's three presents.
#
# So, with five Elves, the Elf that sits starting in position 3 gets all the
# presents.
#
# With the number of Elves given in your puzzle input, which Elf gets all the
# presents?
#
# Your puzzle input is 3014387.
#
#
# An example of the Josephus problem: https://oeis.org/A006257
#
#
# --- Part Two ---
#
# Realizing the folly of their present-exchange rules, the Elves agree to
# instead steal presents from the Elf directly across the circle. If two Elves
# are across the circle, the one on the left (from the perspective of the
# stealer) is stolen from. The other rules remain unchanged: Elves with no
# presents are removed from the circle entirely, and the other elves move in
# slightly to keep the circle evenly spaced.
#
# For example, with five Elves (again numbered 1 to 5):
#
# The Elves sit in a circle; Elf 1 goes first:
#
#     1
#   5   2
#    4 3
#
# Elves 3 and 4 are across the circle; Elf 3's present is stolen, being the one
# to the left. Elf 3 leaves the circle, and the rest of the Elves move in:
#
#     1           1
#   5   2  -->  5   2
#    4 -          4
#
# Elf 2 steals from the Elf directly across the circle, Elf 5:
#
#   1         1
# -   2  -->     2
#   4         4
#
# Next is Elf 4 who, choosing between Elves 1 and 2, steals from Elf 1:
#
#  -          2
#     2  -->
#  4          4
#
# Finally, Elf 2 steals from Elf 4:
#
#  2
#     -->  2
#  -
#
# So, with five Elves, the Elf that sits starting in position 2 gets all the
# presents.
#
# With the number of Elves given in your puzzle input, which Elf now gets all
# the presents?
#

input = 3014387

def next_idx(idx, l)
  (idx + 1) % l.size
end

# PLAY THE GAME
def reduce(input)
  gifts = [1] * input
  count = 0
  idx = 0

  while !gifts.any? {|g| g === input}
    if gifts[idx] == 0
      idx = next_idx(idx, gifts)
      next
    end

    count += 1

    ni = next_idx(idx, gifts)
    ng = gifts[ni]
    while ng == 0
      ni = next_idx(ni, gifts)
      ng = gifts[ni]
    end
    gifts[idx] += ng
    gifts[ni] = 0

    # puts "NEXT %4i TAKES %4i FROM %4i, %4i ELVES LEFT AFTER %4i ROUNDS" % [
    #   idx + 1,
    #   ng,
    #   ni + 1,
    #   input - gifts.count(0),
    #   count,
    # ]

    idx = next_idx(idx, gifts)
  end

  winner = gifts.each_with_index.select {|g, i| g === input}[0][1] + 1

  # puts "RESULT, FROM %3i ONLY %3i %3i HAS GIFTS" % [input, winner, input - winner]
  "%9i %9i" % [input, winner]
end

# pulled from https://www.reddit.com/r/adventofcode/comments/5j4lp1/2016_day_19_solutions/dbdf9mn/
# :(
def reduce2(input)
  # PART 2 RULES
  gifts = (0..(input - 1)).map {|n| n}
  count = 0
  idx = 0

  # start with the lower half of the circle on the left, and the upper half on the right
  left = []
  right = []
  (1..input).each do |n|
    if n < input / 2 + 1
      left << n
    else
      right << n
    end
  end

  # inspect:
  puts "INPUT #{ input }"
  puts "  LEFT  #{ left.inspect }"
  puts "  RIGHT #{ right.inspect }"

  while left.size > 0 && right.size > 0
    # remove from across the circle
    if left.size > right.size
      lost = "L #{ left.pop }"
    else
      lost = "R #{ right.pop }"
    end

    # rotate from left front to right front
    right.unshift left.shift
    # and from right end to left end
    left.push right.pop
    puts "--- #{ lost }"
    puts "  LEFT  #{ left.inspect }"
    puts "  RIGHT #{ right.inspect }"
  end

  winner = left[0] || right[0]

  # puts "FROM %3i ONLY %3i IS LEFT" % [input, winner]
  "%9i %9i" % [input, winner]
end

# JUMP RIGHT TO THE PART ONE SOLUTION
def rol(val)
  # binary rotate left
  "%9i %9i" % [val, val.to_s(2).split('').rotate.join.to_i(2)]
end

puts reduce2(5)
puts reduce2(17)
# puts reduce2(input)

