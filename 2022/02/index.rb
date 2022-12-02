PART_ONE = false

in_file = <<EOS
A Y
B X
C Z
EOS
in_file = in_file.split("\n").map(&:split)

in_file = File.open('input.txt').read.split("\n").map(&:split)

COL1 = { 'A' => :r, 'B' => :p, 'C' => :s }

if PART_ONE
  COL2 = { 'X' => :r, 'Y' => :p, 'Z' => :s }
else
  COL2 = { 'X' => :l, 'Y' => :d, 'Z' => :w }
end

def preproc(l)
  l.map { |(a, b)| [COL1[a], COL2[b]] }
end

PICK = { r: 1, p: 2, s: 3 }
WIN = {
  r: { r: 3, p: 6, s: 0 },
  p: { r: 0, p: 3, s: 6 },
  s: { r: 6, p: 0, s: 3 },
}
BY_OUTCOME = {
  w: { r: :p, p: :s, s: :r },
  l: { r: :s, p: :r, s: :p },
  d: { r: :r, p: :p, s: :s },
}

def score(them, you)
  if PART_ONE
    choice = you
  else
    choice = BY_OUTCOME[you][them]
  end

  PICK[choice] + WIN[them][choice]
end

sum = 0
preproc(in_file).each do |(them, you)|
  sum += score(them, you)
end

puts "TOTAL: #{sum}"