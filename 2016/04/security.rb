#
# --- Day 4: Security Through Obscurity ---
#
# Finally, you come across an information kiosk with a list of
# rooms. Of course, the list is encrypted and full of decoy
# data, but the instructions to decode the list are barely
# hidden nearby. Better remove the decoy data first.
#
# Each room consists of an encrypted name (lowercase letters
# separated by dashes) followed by a dash, a sector ID, and a
# checksum in square brackets.
#
# A room is real (not a decoy) if the checksum is the five
# most common letters in the encrypted name, in order, with
# ties broken by alphabetization. For example:
#
# - aaaaa-bbb-z-y-x-123[abxyz] is a real room because the most
#   common letters are a (5), b (3), and then a tie between x,
#   y, and z, which are listed alphabetically.
# - a-b-c-d-e-f-g-h-987[abcde] is a real room because although
#   the letters are all tied (1 of each), the first five are
#   listed alphabetically.
# - not-a-real-room-404[oarel] is a real room.
# - totally-real-room-200[decoy] is not.
#
# Of the real rooms from the list above, the sum of their
# sector IDs is 1514.
#
# What is the sum of the sector IDs of the real rooms?
#
# --- Part Two ---
#
# With all the decoy data out of the way, it's time to decrypt this list and
# get moving.
#
# The room names are encrypted by a state-of-the-art shift cipher, which is
# nearly unbreakable without the right software. However, the information kiosk
# designers at Easter Bunny HQ were not expecting to deal with a master
# cryptographer like yourself.
#
# To decrypt a room name, rotate each letter forward through the alphabet a
# number of times equal to the room's sector ID. A becomes B, B becomes C, Z
# becomes A, and so on. Dashes become spaces.
#
# For example, the real name for qzmt-zixmtkozy-ivhz-343 is very encrypted
# name.
#
# What is the sector ID of the room where North Pole objects are stored?
#
# Although it hasn't changed, you can still get your puzzle input.
#

PART_ONE = false
INPUT = open('input.txt').readlines().map(&:strip)

# INPUT = %[
# aaaaa-bbb-z-y-x-123[abxyz]
# a-b-c-d-e-f-g-h-987[abcde]
# not-a-real-room-404[oarel]
# totally-real-room-200[decoy]
# ].split()

ALPH = 'abcdefghijklmnopqrstuvwxyz'
def rotate(char, times)
  idx = ALPH.index(char)
  rot = (idx + times) % 26
  ALPH[rot]
end

sector_sum = 0
decodes = []

INPUT.each do |line|
  room = /\d+/.match(line)[0]
  m = /^([^\d]+)/.match(line)[1]

  if PART_ONE
    # letter count
    lc = {}
    m.gsub('-','').each_char do |c|
      lc[c] ||= 0
      lc[c] += 1
    end

    # now as histogram
    hist = lc.each_pair.inject({}) {|memo, (k, v)|
      memo[v] ||= []
      memo[v] << k
      memo
    }

    checksum = hist.keys.sort.reverse.inject([]) {|memo, k|
      hist[k].sort.each {|c| memo << c}
      memo
    }[0, 5].join

    if line.end_with? "[#{ checksum }]"
      puts "CHECK %6s %s %s" % [room, checksum, line]
      sector_sum += room.to_i
    else
      puts "FAIL  %6s %s %s" % [room, checksum, line]
    end
  else
    decodes << m.split('').inject('') { |memo, char|
      if char == '-'
        memo += ' '

      else
        memo += rotate(char, room.to_i)
      end
    }.strip + "  " + room.to_s
  end
end

if PART_ONE
  puts "FINAL %6s" % [sector_sum]
else
  # ha
  puts decodes.grep(/northpole object storage/)
end
