# --- Day 11: Corporate Policy ---
#
# Santa's previous password expired, and he needs help choosing a new one.
#
# To help him remember his new password after the old one expires, Santa has
# devised a method of coming up with a password based on the previous one.
# Corporate policy dictates that passwords must be exactly eight lowercase
# letters (for security reasons), so he finds his new password by incrementing
# his old password string repeatedly until it is valid.
#
# Incrementing is just like counting with numbers: xx, xy, xz, ya, yb, and so on.
# Increase the rightmost letter one step; if it was z, it wraps around to a, and
# repeat with the next letter to the left until one doesn't wrap around.
#
# Unfortunately for Santa, a new Security-Elf recently started, and he has
# imposed some additional password requirements:
#
# - Passwords must include one increasing straight of at least three letters,
#   like abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd doesn't
#   count.
# - Passwords may not contain the letters i, o, or l, as these letters can be
#   mistaken for other characters and are therefore confusing.
# - Passwords must contain at least two different, non-overlapping pairs of
#   letters, like aa, bb, or zz.
#
# For example:
#
# - hijklmmn meets the first requirement (because it contains the straight hij)
#   but fails the second requirement requirement (because it contains i and l).
# - abbceffg meets the third requirement (because it repeats bb and ff) but fails
#   the first requirement.
# - abbcegjk fails the third requirement, because it only has one double letter
#   (bb).
# - The next password after abcdefgh is abcdffaa.
# - The next password after ghijklmn is ghjaabcc, because you eventually skip all
#   the passwords that start with ghi..., since i is not allowed.
#
# Given Santa's current password (your puzzle input), what should his next
# password be?
#
# Your puzzle input is `hepxcrrq`.
#
# -- PART TWO --
#
# Santa's password expired again. What's the next one?
#
# Your puzzle input is still hepxcrrq.

ALPHABET = 'abcdefghijklmnopqrstuvwxyz'
ALPHABET_SIZE = ALPHABET.size

def skip_iol(string)
  if idx = /[iol]/ =~ string
    incr_letter = ALPHABET[ ALPHABET.index(string[idx]) + 1 ]
    out = string[0,idx] + incr_letter + string[(idx + 1..-1)].gsub(/[a-z]/,'a')
    out
  else
    string
  end
end

def increment(string)
  letters = string.split('').reverse
  out = []

  incr  = true
  letters.each do |c|
    idx = ALPHABET.index(c)

    if incr
      # don't increment on the next round by default
      incr = false
      idx += 1
      if idx == ALPHABET_SIZE
        idx = 0
        # carry, increment on the next round
        incr = true
      end
    end

    out << ALPHABET[idx]
  end

  # if new string fails iol rule, immediately skip ahead
  skip_iol(out.reverse.join(''))
end

SEQUENCES = ALPHABET.split('').each_cons(3).to_a.map {|a| a.join('')}

def meets_iol_rule?(string)
  /[iol]/ !~ string
end

def meets_requirement?(string, debug=false)
  # - Passwords may not contain the letters i, o, or l, as these letters can be
  #   mistaken for other characters and are therefore confusing.
  if meets_iol_rule?(string)
    puts "#{ string } MEETS i,o,l RULE" if debug
  else
    puts "#{ string } FAILS i,o,l RULE" if debug
    return false
  end

  # - Passwords must include one increasing straight of at least three letters,
  #   like abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd doesn't
  #   count.
  if SEQUENCES.any? {|seq| /#{ seq }/ =~ string}
    puts "#{ string } MEETS 3 letter straight RULE" if debug
  else
    puts "#{ string } FAILS 3 letter straight RULE" if debug
    return false
  end

  # - Passwords must contain at least two different, non-overlapping pairs of
  #   letters, like aa, bb, or zz.
  prev = nil
  doubles = 0
  string.each_char do |c|
    if prev == nil
      # update prev and skip to next letter
      prev = c
      next
    end

    if c == prev
      doubles += 1
      # reset prev to prevent counting overlapping pairs
      # Example:
      # - aaa is one pair
      # - aaaa is two pairs
      prev = nil
    else
      prev = c
    end
  end

  if doubles < 2
    puts "#{ string } FAILS two doubles RULE" if debug
    return false
  else
    puts "#{ string } MEETS two doubles RULE" if debug
  end

  true
end

TEST = false

if TEST
  test_cases = %w(
    hijklmmn
    abbceffg
    abbcegjk
    mmtuvrsa
    abcdffaa
    ghjaabcc
  )

  test_cases.each do |test|
    if meets_requirement?(test, true)
      puts "-> #{ test } IS VALID"
    end
  end

  input = 'ghijklmn'
  until meets_requirement?(input)
    input = increment(input)
  end
  puts "-> #{ input }"
else
  input = 'hepxcrrq'

  # part two starts with one past: hepxxyzz
  input = increment('hepxxyzz')

  puts "STARTING: #{ input }"

  counter = 0
  until meets_requirement?(input)
    counter += 1
    puts "#{ counter }" if counter % 10000 == 0

    input = increment(input)
  end

  puts "-> #{ input }"
end

