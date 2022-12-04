PART_ONE = false

infile = <<EOS
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
EOS
infile = File.open('input.txt').read

score = lambda {|l| (l >= 'a' && l <= 'z') ? l.ord - 96 : l.ord - 38 }
inter = lambda {|a, b| a.chars.select {|c| b.include?(c) }.uniq.join }

sum = 0
g = []

infile.split("\n").each do |line|
  if PART_ONE 
    s = line.size
    a, b = line[0..(s/2)-1], line[s/2..-1]
    l = inter.(a, b) 
    p = score.(l)
    sum += p

    puts "#{a} | #{b} = #{l} #{p}"
  else
    g << line

    if g.size == 3
      l = inter.(g[0], inter.(g[1], g[2]))
      puts "#{g.inspect} #{l}"
      p = score.(l)
      sum += p
      g = []
    end
  end
end

puts "SCORE #{sum}"
