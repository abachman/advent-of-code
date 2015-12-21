# --- Day 19: Medicine for Rudolph ---
#
# Rudolph the Red-Nosed Reindeer is sick! His nose isn't shining very brightly,
# and he needs medicine.
#
# Red-Nosed Reindeer biology isn't similar to regular reindeer biology; Rudolph
# is going to need custom-made medicine. Unfortunately, Red-Nosed Reindeer
# chemistry isn't similar to regular reindeer chemistry, either.
#
# The North Pole is equipped with a Red-Nosed Reindeer nuclear fusion/fission
# plant, capable of constructing any Red-Nosed Reindeer molecule you need. It
# works by starting with some input molecule and then doing a series of
# replacements, one per step, until it has the right molecule.
#
# However, the machine has to be calibrated before it can be used. Calibration
# involves determining the number of molecules that can be generated in one step
# from a given starting point.
#
# For example, imagine a simpler machine that supports only the following
# replacements:
#
# - H => HO
# - H => OH
# - O => HH
#
# Given the replacements above and starting with HOH, the following molecules
# could be generated:
#
# - HOOH (via H => HO on the first H).
# - HOHO (via H => HO on the second H).
# - OHOH (via H => OH on the first H).
# - HOOH (via H => OH on the second H).
# - HHHH (via O => HH).
#
# So, in the example above, there are 4 distinct molecules (not five, because
# HOOH appears twice) after one replacement from HOH. Santa's favorite molecule,
# HOHOHO, can become 7 distinct molecules (over nine replacements: six from H,
# and three from O).
#
# The machine replaces without regard for the surrounding characters. For
# example, given the string H2O, the transition H => OO would result in OO2O.
#
# Your puzzle input describes all of the possible replacements and, at the
# bottom, the medicine molecule for which you need to calibrate the machine. How
# many distinct molecules can be created after all the different ways you can do
# one replacement on the medicine molecule?
#
# --- Part Two ---
#
# Now that the machine is calibrated, you're ready to begin molecule fabrication.
#
# Molecule fabrication always begins with just a single electron, e, and applying
# replacements one at a time, just like the ones during calibration.
#
# For example, suppose you have the following replacements:
#
# - e => H
# - e => O
# - H => HO
# - H => OH
# - O => HH
#
# If you'd like to make HOH, you start with e, and then make the following
# replacements:
#
# - e => O to get O
# - O => HH to get HH
# - H => OH (on the second H) to get HOH
#
# So, you could make HOH after 3 steps. Santa's favorite molecule, HOHOHO, can be
# made in 6 steps.
#
# How long will it take to make the medicine? Given the available replacements
# and the medicine molecule in your puzzle input, what is the fewest number of
# steps to go from e to the medicine molecule?
#

puts ARGV.inspect
TEST = ARGV[0] == '-t'

if TEST
  in_file = [
  "H => HO\n",
  "H => OH\n",
  "O => HH\n",
  "e => H\n",
  "e => O\n",
  "\n",
  "HOH"
  ]
else
  in_file = open('input.txt').readlines
end

def parse_rule(line)
  if /^([A-Za-z]+) => ([A-Za-z]+)$/ =~ line
    [$1, $2]
  else
    return false, nil
  end
end

rules = {}
input = ''
gather_rules = true
in_file.each do |line|
  if gather_rules
    from, to = parse_rule(line.strip)
  else
    from = false
    to = nil
  end

  if gather_rules && from
    rules[from] ||= []
    rules[from] << to
  elsif gather_rules
    # blank line detected!
    gather_rules = false
    next
  else
    input = line.strip
  end
end

# puts "RULES #{ rules.inspect }"
# puts "INPUT #{ input }"

require 'set'
require 'strscan'

# PART ONE

def solve_part_one(rules, input)
  results = Set.new

  scanner = StringScanner.new(input)
  symbol_matcher = /[A-Z][a-z]?/

  c = scanner.scan(symbol_matcher)
  while c
    idx = scanner.pos - c.size

    puts "MATCHED #{c} AT INDEX #{idx}"

    if variations = rules[c]
      variations.each do |var|
        # first char in the input
        if idx == 0
          result = "%s%s" % [var, input[(idx + c.size)..-1]]
        else
          result = "%s%s%s" % [input[0..(idx-1)], var, input[(idx + c.size)..-1]]
        end

        puts "ADDING #{ result }"

        results.add result
      end
    end

    c = scanner.scan(symbol_matcher)
  end

  puts "RESULTS #{ results.size }"
end

def solve_part_two(rules, input)
  # create reverse substitutions list, order by size DESC
  subs = []
  rules.each do |pattern, variations|
    variations.each do |var|
      subs << [var, pattern]
    end
  end
  subs = subs.sort_by {|(var, patt)| var.size} # .reverse # .map {|(var, patt)| [Regexp.new(var), patt]}

  regexps = {}
  subs.each do |(var, patt)|
    regexps[var] = Regexp.new(var)
    # puts "%-12s%4s" % sub
  end

  # return

  # using subs list, try replacing pieces of input until input => e
  finals = rules['e']
  tries = 0

  original = input

  while !finals.include?(input)
    found = false
    subs.each do |(variation, pattern)|
      # pattern includes variation, replace variation with pattern in input and
      # start over from the beginning of the substituitions list
      if regexps[variation] =~ input
        tries += 1
        pre = input
        input = pre.sub(variation, pattern)
        puts "INPUT #{ pre.size } BECOMES #{ input.size }"
        puts "AFTER #{ variation.to_s } -> #{ pattern }"
        puts
        found = true
        break
      end
    end

    # all substituitions considered, no match found, FAILURE
    if !found
      puts "FAILED TO FURTHER REDUCE INPUT FROM #{ input }"
      break
    end
  end

  if finals.include?(input)
    puts "`#{ original }` CAN BE REACHED FROM `#{ input }` AFTER #{ tries + 1 } SUBSTITUTIONS"
  end
end

# solve_part_one(rules, input)
solve_part_two(rules, input)
