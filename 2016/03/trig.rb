# --- Day 3: Squares With Three Sides ---
#
# Now that you can think clearly, you move deeper into the labyrinth of
# hallways and office furniture that makes up this part of Easter Bunny HQ.
# This must be a graphic design department; the walls are covered in
# specifications for triangles.
#
# Or are they?
#
# The design document gives the side lengths of each triangle it describes,
# but... 5 10 25? Some of these aren't triangles. You can't help but mark the
# impossible ones.
#
# In a valid triangle, the sum of any two sides must be larger than the
# remaining side. For example, the "triangle" given above is impossible,
# because 5 + 10 is not larger than 25.
#
# In your puzzle input, how many of the listed triangles are possible?
#
# --- Part Two ---
#
# Now that you've helpfully marked up their design documents, it occurs to you
# that triangles are specified in groups of three vertically. Each set of three
# numbers in a column specifies a triangle. Rows are unrelated.
#
# For example, given the following specification, numbers with the same
# hundreds digit would be part of the same triangle:
#
# 101 301 501
# 102 302 502
# 103 303 503
# 201 401 601
# 202 402 602
# 203 403 603
#
# In your puzzle input, and instead reading by columns, how many of the listed triangles are possible?

#

# "25 10 5" -> [5, 10, 25]

PART_ONE = false
INPUT = open('input.txt').readlines().map { |l| l.split().map(&:strip).map(&:to_i) }

# INPUT.each {|r| puts "%5i%5i%5i" % r}

if PART_ONE
  count = 0
  total = 0
  INPUT.each do |row|
    a, b, c = row.sort
    # puts "CHECK %i + %i > %i" % [ a, b, c ]
    total += 1
    count += 1 if a + b > c
  end
  puts "POSSIBLE: #{count} of #{total}"
else
  count = 0
  total = 0
  INPUT.each_slice(3) do |rows|

    # zip columns together and sort each flipped block
    flipped = rows[0].zip(*rows[1..-1])

    puts
    puts "---"
    puts "CHUNK"
    puts "  " + rows.map {|r| r.inspect}.join("\n  ")
    puts "FLIPPED"
    puts "  " + flipped.map {|r| r.inspect}.join("\n  ")

    flipped.each do |row|
      a, b, c = row.sort
      puts "CHECK %3i + %3i (%4i) > %3i %s" % [ a, b, a+b, c, (a + b > c).to_s ]
      total += 1
      count += 1 if a + b > c
    end
  end
  puts
  puts "POSSIBLE: #{count} of #{total}"
end
