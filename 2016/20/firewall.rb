# --- Day 20: Firewall Rules ---
#
# You'd like to set up a small hidden computer here so you can use it to get
# back into the network later. However, the corporate firewall only allows
# communication with certain external IP addresses.
#
# You've retrieved the list of blocked IPs from the firewall, but the list
# seems to be messy and poorly maintained, and it's not clear which IPs are
# allowed. Also, rather than being written in dot-decimal notation, they are
# written as plain 32-bit integers, which can have any value from 0 through
# 4294967295, inclusive.
#
# For example, suppose only the values 0 through 9 were valid, and that you
# retrieved the following blacklist:
#
#   5-8
#   0-2
#   4-7
#
# The blacklist specifies ranges of IPs (inclusive of both the start and end
# value) that are not allowed. Then, the only IPs that this firewall allows are
# 3 and 9, since those are the only numbers not in any range.
#
# Given the list of blocked IPs you retrieved from the firewall (your puzzle
# input), what is the lowest-valued IP that is not blocked?
#
#
# --- Part Two ---
#
# How many IPs are allowed by the blacklist?
#
#

input = open('input.txt').readlines().map(&:strip)
# input = ['5-8', '0-2', '4-7']


def solve_1(input)
  min = 2 ** 31
  max = 0
  speculate = 19449262

  count = 0

  low_range = [min, max]

  while count < input.size
    input.each do |line|
      low, high = line.split('-').map(&:to_i).sort
      l, r = low_range

      # puts
      # puts "CHECK %10i : %10i" % [low, high]
      # puts "IN    %10i : %10i" % low_range

      if speculate >= low && speculate <= high
        raise "FOUND #{ speculate } IN #{ line.inspect }"
      end

      if low <= l
        # puts "  LOW BELOW"
        # | ?
        #    | |
        low_range[0] = low

        if high < (l - 1) || high > r
          # puts "    HIGH IN OR OVER"
          # | |
          #    | |
          # or
          # |       |
          #     |  |
          # not
          # |  |
          #    | |
          low_range[1] = high
        end
        # puts "NEXT  %10i : %10i" % low_range
      elsif low > l && low <= (r + 1)
        # puts "  LOW IN"
        #    | ?
        #   |   |

        if high > low_range[1]
          # puts "    HIGH OVER"
          low_range[1] = high
        end
        # puts "NEXT  %10i : %10i" % low_range
      end
    end
    count += 1
  end

  puts '------'
  puts "LOWEST RANGE: #{ low_range.inspect }"
end

solve_1(input)


