# --- Day 17: No Such Thing as Too Much ---
#
# The elves bought too much eggnog again - 150 liters this time. To fit it all
# into your refrigerator, you'll need to move it into smaller containers. You
# take an inventory of the capacities of the available containers.
#
# For example, suppose you have containers of size 20, 15, 10, 5, and 5 liters.
# If you need to store 25 liters, there are four ways to do it:
#
# - 15 and 10
# - 20 and 5 (the first 5)
# - 20 and 5 (the second 5)
# - 15, 5, and 5
#
# Filling all containers entirely, how many different combinations of containers
# can exactly fit all 150 liters of eggnog?

GOAL = 150
in_file = open('input.txt').readlines

# GOAL = 25
# in_file = %w(20 15 10 5 5)

containers = []

in_file.each do |line|
  if /(\d+)/ =~ line
    containers << $1.to_i
  end
end

def sum(ary)
  ary.inject(0, :+)
end

def solve(containers, current, results)
  containers.each_with_index do |c, i|
    current << c
    s = sum(current)
    if s == GOAL
      # FOUND!
      results << current.dup
    elsif s < GOAL
      solve(containers[(i+1)..-1], current, results)
    end
    current.pop
  end
end

results = []
solve(containers, [], results)

puts "RESULTS: #{ results.size }"
# puts "RESULTS: #{ results.inspect }"

min_len = results.sort_by {|r| r.size}.first.size
puts "MINIMUM RESULT LENGTH: #{ min_len }"
puts "RESULTS OF MINIMUM LENGTH: #{ results.select {|r| r.size == min_len}.size }"

