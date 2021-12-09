# https://adventofcode.com/2021/day/8

input = File.open('input.txt').readlines.map(&:strip)
# input = [
#   "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
# ]

TRACE = false
PART_ONE = false
PART_TWO = true

def trace(*msg)
  if TRACE || ENV['TRACE'] == '1'
    puts format(*msg)
  end
end

# a fully contained in b
def has(a, b)
  (b.chars - a.chars).size == (b.size - a.size)
end
# trace '%s', has('asdf', 'asdfe').inspect
# trace '%s', has('asd', 'asdfe').inspect
# trace '%s', has('fff', 'asdfe').inspect
# trace '%s', has('abc', 'asdfe').inspect
# trace '%s', has('efs', 'asdfe').inspect

# which segments of a is b missing?
def diffs(a, b)
  a.chars - b.chars
end

trace '%s', diffs('abc', 'acdef').inspect

def norm(word)
  word.chars.sort.join('')
end

# given 10 digits with crossed up wires, produce a lookup table of normalized code -> actual digit
def solve(codes)
  codes = codes.map {|c| norm(c)}

  zero = ''
  one = codes.find {|c| c.size == 2}
  two = ''
  three = ''
  four = codes.find {|c| c.size == 4}
  five = ''
  six = ''
  seven = codes.find {|c| c.size == 3}
  eight = codes.find {|c| c.size == 7}
  nine = ''

  # 2, 3, 5, 9, 0

  # size
  # 7: 8
  # 6: 9, 0, 6
  # 5: 2, 3, 5
  # 4: 4
  # 3: 7
  # 2: 1

  # 9, 0, 6
  sixers = codes.select {|c| c.size == 6 }
  trace "%i sixers", sixers.size

  # 9 has all of 4, 0 and 6 do not
  nine = sixers.find {|c| has(four, c) }

  fivers = codes.select {|c| c.size == 5 }
  trace "%i fivers", fivers.size

  # 3 and 5 have no diffs with 9, 2 has 1
  two = fivers.find {|c| diffs(c, nine).size == 1}

  # 3 has 1 diff with 2 and 5 has 2
  three = fivers.find {|c| diffs(c, two).size == 1}
  five = fivers.find {|c| diffs(c, two).size == 2}

  # 5 is wholly contained in 6, 0 is not
  six = (sixers - [nine]).find {|c| has(five, c)}
  zero = (sixers - [nine]).find {|c| !has(five, c)}

  # originally
  #
  #   aaaa
  #  b    c
  #  b    c
  #   dddd
  #  e    f
  #  e    f
  #   gggg
  #

  trace "----- %s", codes.join(' . ')
  trace "zero:  %s", zero
  trace "one:   %s", one
  trace "two:   %s", two
  trace "three: %s", three
  trace "four:  %s", four
  trace "five:  %s", five
  trace "six:   %s", six
  trace "seven: %s", seven
  trace "eight: %s", eight
  trace "nine:  %s", nine

  {
    zero => 0,
    one => 1,
    two => 2,
    three => 3,
    four => 4,
    five => 5,
    six => 6,
    seven => 7,
    eight => 8,
    nine => 9
  }
end

digicount = 0
sum = 0
input.each do |line|
  left, right = line.split('|').map {|side| side.split(' ')}

  if PART_ONE
    right.each do |word|
        digicount += case word.size
                    when 2, 3, 4, 7
                      1
                    else
                      0
                    end
    end
  end

  if PART_TWO
    lookup = solve(left)
    print format("%40s: ", right.join(' '))

    num = []
    right.each do |word|
      word = norm(word)
      num << lookup[norm(word)]
      print num.last
    end

    sum += num.map(&:to_s).join('').to_i

    puts
  end
end

if PART_ONE
  puts "PART_ONE COUNT: #{digicount}"
end

if PART_TWO
  puts "PART_TWO SUM: #{sum}"
end
