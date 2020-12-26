## Part 1
#
# To try to debug the problem, they have created a list (your puzzle
# input) of passwords (according to the corrupted database) and the
# corporate policy when that password was set.
#
# For example, suppose you have the following list:
#
#   1-3 a: abcde
#   1-3 b: cdefg
#   2-9 c: ccccccccc
#
# Each line gives the password policy and then the password. The
# password policy indicates the lowest and highest number of times a
# given letter must appear for the password to be valid. For example,
#   1-3 a means that the password must contain a at least 1 time and at
# most 3 times.
#
# In the above example, 2 passwords are valid. The middle password,
# cdefg, is not; it contains no instances of b, but needs at least 1.
# The first and third passwords are valid: they contain one a or nine
# c, both within the limits of their respective policies.
#
# How many passwords are valid according to their policies?
#
## Part 2
#
# While it appears you validated the passwords correctly, they don't seem to be
# what the Official Toboggan Corporate Authentication System is expecting.
#
# The shopkeeper suddenly realizes that he just accidentally explained the
# password policy rules from his old job at the sled rental place down the
# street! The Official Toboggan Corporate Policy actually works a little
# differently.
#
# Each policy actually describes two positions in the password, where 1 means
# the first character, 2 means the second character, and so on. (Be careful;
# Toboggan Corporate Policies have no concept of "index zero"!) Exactly one of
# these positions must contain the given letter. Other occurrences of the
# letter are irrelevant for the purposes of policy enforcement.
#
# Given the same example list from above:
#
#   1-3 a: abcde is valid: position 1 contains a and position 3 does not.
#   1-3 b: cdefg is invalid: neither position 1 nor position 3 contains b.
#   2-9 c: ccccccccc is invalid: both position 2 and position 9 contain c.
#
# How many passwords are valid according to the new interpretation of the
# policies?



# data = %[1-3 a: abcde
# 1-3 b: cdefg
# 2-9 c: ccccccccc].split("\n").map {|l| l.chomp; l.split(':').map(&:strip)}
data = File.readlines('input.txt').
  map(&:chomp).
  compact.
  map {|l| l.split(':').map(&:strip) }

valid = 0

def is_part1_valid(passwd, letter, lmin, lmax)
  c = passwd.count(letter)
  puts format("%s INCLUDES %s %i TIMES",
              passwd , letter, passwd.count(letter))


  return c >= lmin && c <= lmax
end

def is_part2_valid(passwd, letter, lmin, lmax)
  return (passwd[lmin - 1] == letter && passwd[lmax - 1] != letter) ||
         (passwd[lmin - 1] != letter && passwd[lmax - 1] == letter)
end


data.each do |line|
  count, letter = line[0].split(' ')
  lmin, lmax = count.split('-').map(&:to_i)
  passwd = line[1]

  puts "LINE: #{line.inspect} #{{
    count: count,
    letter: letter,
    lmin: lmin,
    lmax: lmax,
    passwd: passwd
  }}"

  # PART 1
  # if is_part1_valid(passwd, letter, lmin, lmax)
  #   valid += 1
  # end
  if is_part2_valid(passwd, letter, lmin, lmax)
    valid += 1
  end
end

puts "#{valid} VALID PASSWORDS"
