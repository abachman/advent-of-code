in_file = <<EOS
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
EOS

in_file = File.open('input.txt').read

def parse(inpt)
  sum = 0
  inpt.lines.each do |line|
    line = line.chomp
    if line == ''
      yield sum

      sum = 0
    else
      sum += line.to_i
    end
  end
end

max_elf = -1
elves = []
parse(in_file) do |elf|
  elves << elf
  puts "ELF: #{elf}"
  max_elf = elf if elf > max_elf
end

puts "MAX: #{max_elf}"
tops = elves.sort.reverse[0..2]
puts "TOP: #{tops.inspect} #{tops.sum}"
