# The automatic passport scanners are slow because they're having trouble
# detecting which passports have all required fields. The expected fields are
# as follows:
#
#   byr (Birth Year)
#   iyr (Issue Year)
#   eyr (Expiration Year)
#   hgt (Height)
#   hcl (Hair Color)
#   ecl (Eye Color)
#   pid (Passport ID)
#   cid (Country ID)
#
# Passport data is validated in batch files (your puzzle input). Each passport
# is represented as a sequence of key:value pairs separated by spaces or
# newlines. Passports are separated by blank lines.
#
# Here is an example batch file containing four passports:
#
#   ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
#   byr:1937 iyr:2017 cid:147 hgt:183cm
#
#   iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
#   hcl:#cfa07d byr:1929
#
#   hcl:#ae17e1 iyr:2013
#   eyr:2024
#   ecl:brn pid:760753108 byr:1931
#   hgt:179cm
#
#   hcl:#cfa07d eyr:2025 pid:166559648
#   iyr:2011 ecl:brn hgt:59in
#
# The first passport is valid - all eight fields are present. The second
# passport is invalid - it is missing hgt (the Height field).
#
# The third passport is interesting; the only missing field is cid, so it looks
# like data from North Pole Credentials, not a passport at all! Surely, nobody
# would mind if you made the system temporarily ignore missing cid fields.
# Treat this "passport" as valid.
#
# The fourth passport is missing two fields, cid and byr. Missing cid is fine,
# but missing any other field is not, so this passport is invalid.
#
# According to the above rules, your improved system would report 2 valid
# passports.
#
# Count the number of valid passports - those that have all required fields.
# Treat cid as optional. In your batch file, how many passports are valid?

## --- Part Two ---
#
# The line is moving more quickly now, but you overhear airport security
# talking about how passports with invalid data are getting through. Better add
# some data validation, quick!
#
# You can continue to ignore the cid field, but each other field has strict
# rules about what values are valid for automatic validation:
#
#   byr (Birth Year) - four digits; at least 1920 and at most 2002.
#   iyr (Issue Year) - four digits; at least 2010 and at most 2020.
#   eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
#   hgt (Height) - a number followed by either cm or in:
#     If cm, the number must be at least 150 and at most 193.
#     If in, the number must be at least 59 and at most 76.
#   hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
#   ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
#   pid (Passport ID) - a nine-digit number, including leading zeroes.
#   cid (Country ID) - ignored, missing or not.
#
# Your job is to count the passports where all required fields are both present
# and valid according to the above rules.
#
# Here are some invalid passports:
#
#   eyr:1972 cid:100
#   hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926
#
#   iyr:2019
#   hcl:#602927 eyr:1967 hgt:170cm
#   ecl:grn pid:012533040 byr:1946
#
#
# Here are some valid passports:
#
#   pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
#   hcl:#623a2f
#
#   eyr:2029 ecl:blu cid:129 byr:1989
#   iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm
#
#
# Count the number of valid passports - those that have all required fields and
# valid values. Continue to treat cid as optional. In your batch file, how many
# passports are valid?
#

data = File.readlines('input.txt').map(&:chomp)
data << ''

pp = []
pps = []

def convert(pp)
  Hash[pp.join(' ').split(' ').map {|e| e.split(':')}]
end

data.each do |line|
  if line == '' && pp.size > 0
    pps << convert(pp)
    pp = []
  else
    pp << line
  end
end

# puts pps.inspect

## PART 1
#
# rules = %w(byr iyr eyr hgt hcl ecl pid)
# valid = 0
#
# pps.each do |pp|
#   # pp is a hash with field keys
#   if rules.any? {|rule| pp[rule].nil?}
#     puts "BAD, MISSING: #{rules.filter {|r| pp[r].nil?}}"
#   else
#     puts "GOOD!"
#     valid += 1
#   end
# end
#
# puts "COUNT: #{pps.size}"
# puts "VALID: #{valid}"

# PART 2

rules = %w(byr iyr eyr hgt hcl ecl pid)
valid = 0

def valid?(pp, rule)
  v = pp[rule]
  return false if v.nil?

  # part 1
  # return true

  #   byr (Birth Year) - four digits; at least 1920 and at most 2002.
  #   iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  #   eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  #   hgt (Height) - a number followed by either cm or in:
  #     If cm, the number must be at least 150 and at most 193.
  #     If in, the number must be at least 59 and at most 76.
  #   hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  #   ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  #   pid (Passport ID) - a nine-digit number, including leading zeroes.
  #   cid (Country ID) - ignored, missing or not.
  # part 2
  case rule
  when 'byr'
    return v.to_i >= 1920 && v.to_i <= 2002
  when 'iyr'
    return v.to_i >= 2010 && v.to_i <= 2020
  when 'eyr'
    return v.to_i >= 2020 && v.to_i <= 2030
  when 'hgt'
    m = /(\d+)(cm|in)/.match(v)
    return false unless m && m[1] && m[2]
    n, t = m[1].to_i, m[2]
    return t == 'cm' ?
      (n >= 150 && n <= 193) :
      (n >= 59 && n <= 76)
  when 'hcl'
    return /^#[a-f0-9]{6}$/ =~ v
  when 'ecl'
    return %w(amb blu brn gry grn hzl oth).include?(v)
  when 'pid'
    return /^[0-9]{9}$/ =~ v
  end
end

pps.each_with_index do |pp, i|
  # pp is a hash with field keys
  if rules.all? { |rule| valid?(pp, rule).tap {|v| puts "#{i} FAILED ON #{rule} #{pp[rule].inspect}" unless v} }
    puts "GOOD!"
    valid += 1
  else
    puts "BAD #{pp}"
  end
end

puts "COUNT: #{pps.size}"
puts "VALID: #{valid}"
