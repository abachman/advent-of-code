# https://adventofcode.com/2021/day/14
#
# l-system-ish
#
# NOTE: I had to cheat for part 2 :( BUT, I was able to eventually get the
# correct answers.
#
# Using the string building solution worked for Part 1. I built a string,
# counted characters, and done. In part two, iterating 40 times, the brute force
# solution had no chance.
#
# I switched to a pair-counting solution, but didn't understand how to get from
# there to character counts. Looking at someone else's code, I found the idea to
# count pairs AND single characters from the beginning. There were a couple of
# gross, very-long-to-debug problems with logic errors in my initial pair
# counter and in my totals counter.
#
# The first only showed up when I ran on input.txt vs demo.txt and the second
# only showed up when I ran 40 repetitions.
#

require 'bigdecimal'

input = File.open('input.txt').readlines.map {|l| l.strip }

TIMES = 40
TRACE = true
PART_ONE = true
PART_TWO = false

def trace(*msg)
  if TRACE || ENV['TRACE'] == '1'
    puts format(*msg)
  end
end

def parse(lines)
  rules = {}
  start = {}
  lines[0].chars.each_cons(2) do |a, b|
    pair = a + b
    start[pair] = start.fetch(pair, 0) + 1
  end

  chars = cdict(lines[0])

  lines[2..-1].each do |rule|
    pair, insert = rule.split(' -> ')
    rules[pair] = insert
  end

  [ start, rules, chars ]
end

def step(pairs, chars, rules, iter: 0)
  iter.times do |n|
    npairs = {}

    rules.each do |(pair, insert)|
      if pairs[pair]
        count = pairs[pair]
        left = pair[0] + insert
        right = insert + pair[1]

        chars[insert] = chars.fetch(insert, 0) + count
        npairs[left] = npairs.fetch(left, 0) + count
        npairs[right] = npairs.fetch(right, 0) + count
      end
    end

    pairs = npairs
  end
end

def count(chars)
  minc = BigDecimal::INFINITY
  maxc = -BigDecimal::INFINITY

  chars.each do |(c, count)|
    trace '  %s %i', c, count
    minc = [ minc, count ].min
    maxc = [ maxc, count ].max
  end

  maxc - minc
end

def cdict(instr)
  instr.chars.inject({}) {|memo, obj| memo[obj] ||= 0; memo[obj] += 1; memo}
end

pairs, rules, chars = parse(input)

race "LINE"
trace "   %s", input[0]
trace "PAIRS"
trace "   %s", pairs.map {|(k, v)| "#{k} #{v}"}.join("\n   ")
trace "CHARS"
chars.each do |(c, count)|
  trace '   %s %i', c, count
end

step(pairs, chars, rules, iter: TIMES)

puts format("ANSWER: %i", count(chars))

