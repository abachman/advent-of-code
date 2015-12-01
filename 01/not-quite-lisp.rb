
in_file = open('input.txt').read

# start on (floor 0)
floor = 0

# track basement access
stack = []
announce = false

# An opening parenthesis, (, means Santa should go up one floor, and a closing
# parenthesis, ), means Santa should go down one floor.
in_file.chars.each do |char|
  stack << char
  if char == '('
    floor += 1
    # go up
  elsif char == ')'
    floor -= 1
    # go down
  end

  if floor < 0 && announce == false
    puts "Santa has entered the basement on (instruction #{ stack .size })"
    announce = true
  end
end

puts "Santa should be on (floor #{ floor })"
