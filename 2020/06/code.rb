data = File.readlines('input.txt').map(&:chomp)
data << ''

group = []
groups = []

def convert_part1(gp)
  puts "convert(#{gp})"
  gp.join('').
    chars.
    inject({}) {|memo, obj| memo[obj] = true; memo}
end

def convert_part2(gp)
  puts "convert2(#{gp})"
  gp.inject({}) do |memo, answers|

    answers.chars.each do |c|
      memo[c] ||= 0
      memo[c] += 1
    end

    memo
  end.reject do |k, v|
    v < gp.size
  end
end

data.each do |line|
  if line == '' && group.size > 0
    groups << convert_part2(group)
    group = []
  else
    group << line
  end
end

count = groups.map(&:keys).inject(0) {|sum, keys| sum += keys.size; sum}

puts "ANSWERS: #{count}"
# part 1
# ANSWERS: 6335

# part 2
#
