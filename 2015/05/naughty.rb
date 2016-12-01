# --- Day 5: Doesn't He Have Intern-Elves For This? ---
#
# Santa needs help figuring out which strings in his text file are naughty or
# nice.
#
# A nice string is one with all of the following properties:
#
# - It contains at least three vowels (aeiou only), like aei, xazegov, or
#   aeiouaeiouaeiou.
# - It contains at least one letter that appears twice in a row, like xx,
#   abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
# - It does not contain the strings ab, cd, pq, or xy, even if they are part of
#   one of the other requirements.
#
# For example:
#
# - ugknbfddgicrmopn is nice because it has at least three vowels
#   (u...i...o...), a double letter (...dd...), and none of the disallowed
#   substrings.
# - aaa is nice because it has at least three vowels and a double letter, even
#   though the letters used by different rules overlap.
# - jchzalrnumimnmhp is naughty because it has no double letter.
# - haegwjzuvuyypxyu is naughty because it contains the string xy.
# - dvszwmarrgswjxmb is naughty because it contains only one vowel.
#
# How many strings are nice?
#
#
# --- Part Two ---
#
# Realizing the error of his ways, Santa has switched to a better model of
# determining whether a string is naughty or nice. None of the old rules apply,
# as they are all clearly ridiculous.
#
# Now, a nice string is one with all of the following properties:
#
# - It contains a pair of any two letters that appears at least twice in the
#   string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like
#   aaa (aa, but it overlaps).
# - It contains at least one letter which repeats with exactly one letter
#   between them, like xyx, abcdefeghi (efe), or even aaa.
#
# For example:
#
# - qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and
#   a letter that repeats with exactly one letter between them (zxz).
# - xxyxx is nice because it has a pair that appears twice and a letter that
#   repeats with one between, even though the letters used by each rule overlap.
# - uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a
#   single letter between them.
# - ieodomkazucvgmuy is naughty because it has a repeating letter with one
#   between (odo), but no pair that appears twice.
#
# How many strings are nice under these new rules?
#

in_file = open('input.txt').readlines

# in_file = %w(
# ugknbfddgicrmopn
# aaa
# jchzalrnumimnmhp
# haegwjzuvuyypxyu
# dvszwmarrgswjxmb
# )

# print in_file

def is_naughty(word)
  puts "#{ word.strip } is naughty"
end

def is_nice(word)
  puts "#{ word.strip } is nice!"
end

def has_double_letter?(word)
  word.each_char.each_with_index do |letter, i|
    if word.size > i + 1
      next_letter = word[ i + 1 ]
    else
      return false
    end

    if letter == next_letter
      return true
    end
  end
end

def word_fails_part_1_rules?(word)
  # rule 1
  if word.scan(/[aeiou]/).size < 3
    # is_naughty(word)
    return true
  end

  # rule 2
  if not has_double_letter?(word)
    # is_naughty(word)
    return true
  end

  # rule 3
  if /(ab|cd|pq|xy)/ =~ word
    # is_naughty(word)
    return true
  end
end

def has_double_pair?(word)
  word.each_char.each_with_index do |letter, i|
    this_pair = word[i, 2]

    if word.size > i + 3
      rest_of_word = word[i+2..-1]

      if /#{ this_pair }/ =~ rest_of_word
        # this pair occurs again in the rest of the word
        return true
      end
    else
      # rest of word is too short to contain a match!
      return false
    end
  end
end

def has_gapped_letter_match?(word)
  word.each_char.each_with_index do |letter, i|
    if word.size > i + 2
      gapped_letter = word[i + 2]

      if letter == gapped_letter
        # this letter occurs again after a gap
        return true
      end
    else
      # rest of word is too short to contain a match!
      return false
    end
  end
end

def word_fails_part_2_rules?(word)
  # Is nice if...
  #
  # It contains a pair of any two letters that appears at least twice in the
  # string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like
  # aaa (aa, but it overlaps).
  if not has_double_pair?(word)
    return true
  end

  # It contains at least one letter which repeats with exactly one letter
  # between them, like xyx, abcdefeghi (efe), or even aaa.
  if not has_gapped_letter_match?(word)
    return true
  end

  return false
end

## Check Words

nice_counter = 0
in_file.each do |word|
  # if word_fails_part_1_rules?(word)
  #   is_naughty(word)
  #   next
  # end

  if word_fails_part_2_rules?(word)
    is_naughty(word)
    next
  end

  nice_counter += 1
  is_nice(word)
end

puts "There are #{ nice_counter } nice words!"
