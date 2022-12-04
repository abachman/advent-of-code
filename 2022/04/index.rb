infile = <<EOS
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
EOS

infile = File.open('input.txt').read

count_1 = 0
count_2 = 0

is_in = ->(a, b){ a[0] <= b[0] && a[1] >= b[1] }
overlap = ->(a, b){ a[1] >= b[0] && a[0] <= b[1] }

infile.lines.each do |line|
  a, b = line.split(',').map {|p| p.split('-').map(&:to_i) }
  count_1 += 1 if is_in.(a, b) || is_in.(b, a)
  count_2 += 1 if overlap.(a, b)

  puts "#{a.inspect} in #{b.inspect}"
end

puts "TOTAL PART 1: #{count_1}"
puts "TOTAL PART 2: #{count_2}"


