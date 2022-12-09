PART_ONE = false

infile = <<EOS
zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw
EOS

infile = File.open('input.txt').read

str = infile.lines.map(&:chomp).filter(&:size).first

def start(i)
  seq = []
  i.chars.each_with_index do |c, idx|
    seq << c

    return idx + 1 if seq.uniq.size == 14

    seq.shift if seq.size > 13
  end
end

puts "AFTER: #{start(str)}"
