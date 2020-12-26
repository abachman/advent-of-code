# Before you leave, the Elves in accounting just need you to fix your expense
# report (your puzzle input); apparently, something isn't quite adding up.
#
# Specifically, they need you to find the two entries that sum to 2020 and then
# multiply those two numbers together.
#
# For example, suppose your expense report contained the following:
#
#     1721
#     979
#     366
#     299
#     675
#     1456
#
# In this list, the two entries that sum to 2020 are 1721 and 299. Multiplying
# them together produces 1721 * 299 = 514579, so the correct answer is 514579.
#
# Of course, your expense report is much larger. Find the two entries that sum to
# 2020; what do you get if you multiply them together?
#
# The Elves in accounting are thankful for your help; one of them even offers you
# a starfish coin they had left over from a past vacation. They offer you a
# second one if you can find three numbers in your expense report that meet the
# same criteria.
#
# Using the above example again, the three entries that sum to 2020 are 979, 366,
# and 675. Multiplying them together produces the answer, 241861950.
#
# In your expense report, what is the product of the three entries that sum to
# 2020?

data = File.readlines('input.txt').map(&:to_i).compact

# data = %w[ 1721 979 366 299 675 1456 ].map(&:to_i)
found = false

(0..(data.size - 1)).each do |ai|
  an = data[ai]

  (0..(data.size - 1)).each do |bi|
    next if ai == bi

    bn = data[bi]

    # part 1
    # if an + bn === 2020
    #   puts "FOUND #{an} + #{bn}"
    #   puts "SOLUTION: #{an * bn}"
    #   found = true
    #   break
    # end

    (0..(data.size - 1)).each do |ci|
      next if ai == ci || bi == ci

      cn = data[ci]

      if an + bn + cn === 2020
        puts "FOUND #{an} + #{bn} + #{cn}"
        puts "SOLUTION: #{an * bn * cn}"
        found = true
        break
      end
    end
    break if found
  end
  break if found
end

puts "DONE"

