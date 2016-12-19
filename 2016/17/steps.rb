# --- Day 17: Two Steps Forward ---
#
# You're trying to access a secure vault protected by a 4x4 grid of small rooms
# connected by doors. You start in the top-left room (marked S), and you can
# access the vault (marked V) once you reach the bottom-right room:
#
#   #########
#   #S| | | #       start [0, 0]
#   #-#-#-#-#
#   # | | | #
#   #-#-#-#-#
#   # | | | #
#   #-#-#-#-#
#   # | | |  #      end   [3, 3]
#   ####### V#
#          ###
#
#   4 x 4
#
# Fixed walls are marked with #, and doors are marked with - or |.
#
# The doors in your current room are either open or closed (and locked) based
# on the hexadecimal MD5 hash of a passcode (your puzzle input) followed by a
# sequence of uppercase characters representing the path you have taken so far
# (U for up, D for down, L for left, and R for right).
#
# Only the first four characters of the hash are used; they represent,
# respectively, the doors up, down, left, and right from your current position.
# Any b, c, d, e, or f means that the corresponding door is open; any other
# character (any number or a) means that the corresponding door is closed and
# locked.
#
# To access the vault, all you need to do is reach the bottom-right room;
# reaching this room opens the vault and all doors in the maze.
#
# For example, suppose the passcode is hijkl. Initially, you have taken no
# steps, and so your path is empty: you simply find the MD5 hash of hijkl
# alone. The first four characters of this hash are ced9, which indicate that
# up is open (c), down is open (e), left is open (d), and right is closed and
# locked (9). Because you start in the top-left corner, there are no "up" or
# "left" doors to be open, so your only choice is down.
#
# Next, having gone only one step (down, or D), you find the hash of hijklD.
# This produces f2bc, which indicates that you can go back up, left (but that's
# a wall), or right. Going right means hashing hijklDR to get 5745 - all doors
# closed and locked. However, going up instead is worthwhile: even though it
# returns you to the room you started in, your path would then be DU, opening a
# different set of doors.
#
# After going DU (and then hashing hijklDU to get 528e), only the right door is
# open; after going DUR, all doors lock. (Fortunately, your actual passcode is
# not hijkl).
#
# Passcodes actually used by Easter Bunny Vault Security do allow access to the
# vault if you know the right path. For example:
#
# - If your passcode were ihgpwlah, the shortest path would be DDRRRD.
# - With kglvqrro, the shortest path would be DDUDRLRRUDRD.
# - With ulqzkmiv, the shortest would be DRURDRUDDLLDLUURRDULRLDUUDDDRR.
#                                        DRURDRUDDLLDLUURRDULRLDUUDDDRR
#
# Given your vault's passcode, what is the shortest path (the actual path, not
# just the length) to reach the vault?
#
# Your puzzle input is rrrbmfta.
#
#
# --- Part Two ---
#
# You're curious how robust this security solution really is, and so you decide
# to find longer and longer paths which still provide access to the vault. You
# remember that paths always end the first time they reach the bottom-right
# room (that is, they can never pass through it, only end in it).
#
# For example:
#
# - If your passcode were ihgpwlah, the longest path would take 370 steps.
# - With kglvqrro, the longest path would be 492 steps long.
# - With ulqzkmiv, the longest path would be 830 steps long.
#
# What is the length of the longest path that reaches the vault?
#
#

require 'digest'
MD5 = Digest('MD5')
# MAX_DEPTH = 50
W = 4
H = 4

# actual
input = 'rrrbmfta'

# # test 1
# input = 'ihgpwlah'
# # test 3
# input = 'ulqzkmiv'

start = [0, 0]

DIRECTIONS = {
  'U' => [ 0,-1],
  'D' => [ 0, 1],
  'R' => [ 1, 0],
  'L' => [-1, 0]
}

def check(input, d)
  h = MD5.hexdigest(input)
  c = h[ 'UDLR'.index(d) ]
  'bcdef'.include?(c)
end

# Depth first, brute force
def solve(position, input, solutions=[], level=0)
  ind = ' ' * level
  DIRECTIONS.each_pair do |(d, move)|
    # puts ind + "CHECK #{ input } #{ d }"
    if check(input, d)
      np = [ position[0] + move[0], position[1] + move[1] ]
      ni = input + d

      if np[0] === 3 && np[1] === 3
        # found a solution
        # puts ind + "SOLUTION AT #{ ni }"
        solutions << ni
        next
      elsif np[0] < 0 || np[0] === W || np[1] < 0 || np[1] === H
        # puts ind + "! OUT OF BOUNDS #{ np.inspect }"
        next
      # elsif level > MAX_DEPTH
      #   # puts ind + "! BAILING AT #{ ni }"
      #   next
      else
        # puts ind + "> UNLOCKED, MOVE #{ d } TO #{ np.inspect } #{ ni }"
        solve(np, ni, solutions, level + 1)
      end
    end
  end
end

solutions = []
solve(start, input, solutions)

puts "FOUND #{ solutions.size } SOLUTIONS, THE FOUR LONGEST ARE"

solutions.sort_by {|s| s.size }[(solutions.size - 4)..-1].each do |s|
  result = s[input.size..-1]
  puts "%4i    %s" % [result.size, result]
end

