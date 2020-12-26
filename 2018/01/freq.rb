

sum = 0
lines = open('input.txt').readlines()

seen = {}
first_double = nil

while first_double.nil?
  lines.each do |l|
    sum += l.chomp.to_i

    if seen[sum] && first_double.nil?
      first_double = sum
    end

    seen[sum] = true
  end
end

# puts "PART 1", sum
puts "PART 2", first_double


