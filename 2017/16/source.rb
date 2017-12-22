# --- Day 16: Permutation Promenade ---
#
# You come upon a very unusual sight; a group of programs here appear
# to be dancing.
#
# There are sixteen programs in total, named a through p. They start
# by standing in a line: a stands in position 0, b stands in position
# 1, and so on until p, which stands in position 15.
#
# The programs' dance consists of a sequence of dance moves:
#
# - Spin, written sX, makes X programs move from the end to the
#   front, but maintain their order otherwise. (For example, s3 on
#   abcde produces cdeab).
# - Exchange, written xA/B, makes the programs at positions A and B
#   swap places.
# - Partner, written pA/B, makes the programs named A and B swap
#   places.
#
# For example, with only five programs standing in a line (abcde),
# they could do the following dance:
#
# - s1, a spin of size 1: eabcd.
# - x3/4, swapping the last two programs: eabdc.
# - pe/b, swapping programs e and b: baedc.
#
# After finishing their dance, the programs end up in order baedc.
#
# You watch the dance for a while and record their dance moves (your
# puzzle input). In what order are the programs standing after their
# dance?
#
#
#--- Part Two ---
#
# Now that you're starting to get a feel for the dance moves, you
# turn your attention to the dance as a whole.
#
# Keeping the positions they ended up in from their previous dance,
# the programs perform it again and again: including the first dance,
# a total of one billion (1000000000) times.
#
# In the example above, their second dance would begin with the order
# baedc, and use the same dance moves:
#
# s1, a spin of size 1: cbaed.
# x3/4, swapping the last two programs: cbade.
# pe/b, swapping programs e and b: ceadb.
#
# In what order are the programs standing after their billion dances?
#

PART_ONE = ENV['TWO'] != '1'

# MY INPUT
input = open('input.txt').read().split(',')

# store program names as list of bytes, do all manipulations on bytes

SPINS = (0..16).map do |n|
  ('0x' + ('f' * n)).to_i(16)
end

IDX_BYTES = (0..15).map do |n|
  (0xf << (4 * n))
end.reverse

STEP = 4
BYTES = 16

def spin_bytes(bytes, times)
  r = bytes & SPINS[times]
  (r << (STEP * (BYTES - times))) | (bytes >> (STEP * times))
end

def swap_index_bytes(bytes, a, b)
  ta = (bytes & IDX_BYTES[a])
  tb = (bytes & IDX_BYTES[b])

  # replacement
  (bytes ^ ta ^ tb) |
    (ta >> (4 * (BYTES - a - 1))) << (4 * (BYTES - b - 1)) |
    (tb >> (4 * (BYTES - b - 1))) << (4 * (BYTES - a - 1))
end

def swap_value_bytes(bytes, a, b)
  # idx of a
  ia = -1
  ib = -1
  i = 0

  while i < 16 do
    if ia == -1 && ((bytes & IDX_BYTES[i]) >> (4 * (BYTES - i - 1))) === a
      ia = i
    end

    if ib == -1 && ((bytes & IDX_BYTES[i]) >> (4 * (BYTES - i - 1))) === b
      ib = i
    end

    i += 1
  end

  swap_index_bytes bytes, ia, ib
end

# converting from list of bytes to list of letters
LETTERS = %w(a b c d e f g h i j k l m n o p)
LETTER_TO_BYTE = {}
BYTE_TO_LETTER = {}
LETTERS.each_with_index do |l, idx|
  LETTER_TO_BYTE[l] = idx
  BYTE_TO_LETTER[idx] = l
end

def run_bytes(instructions, bytes)
  instructions.each do |inst|
    # puts "INST #{inst}"
    case inst
    when /s(\d+)/
      # puts "SPIN #{$1}"
      bytes = spin_bytes(bytes, $1.to_i)
    when /x(\d+)\/(\d+)/
      # puts "SWAP IDX #{$1} #{$2}"
      bytes = swap_index_bytes(bytes, $1.to_i, $2.to_i)
    when /p([a-p]+)\/([a-p]+)/
      # puts "SWAP VAL #{$1} #{$2}"
      bytes = swap_value_bytes(bytes, LETTER_TO_BYTE[$1], LETTER_TO_BYTE[$2])
    end
  end

  bytes
end

def repr(bytes)
  (0..(BYTES - 1)).map do |n|
    BYTE_TO_LETTER[ ((bytes & IDX_BYTES[n]) >> (4 * (BYTES - n - 1))) ]
  end.join('')
end

# use big number instead of an array of letters
bytes = 0x0123456789abcdef
# maps to ^
#         abcdefghijklmnop

if PART_ONE
  bytes = run_bytes(input, bytes)
  print "PART ONE: "
  puts repr(bytes)
  puts
else
  iter = 0
  seen = {}

  while seen[bytes].nil?
    seen[bytes] = true
    bytes = run_bytes(input, bytes)
    iter += 1
  end


  extra = 1_000_000_000 % iter

  puts "REPEATED AFTER #{iter} CYCLES, RUN #{extra} MORE TIMES"

  extra.times do
    bytes = run_bytes(input, bytes)
  end

  print "PART TWO "
  puts repr(bytes)
end
