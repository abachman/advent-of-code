PART_ONE = false

# DEMO
#
#     [D]    
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 

infile = <<EOS
move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
EOS

stacks = [
  nil, 
  %w(Z N),
  %w(M C D),
  %w(P)
]

# ACTUAL
#
#     [W]         [J]     [J]        
#     [V]     [F] [F] [S] [S]        
#     [S] [M] [R] [W] [M] [C]        
#     [M] [G] [W] [S] [F] [G]     [C]
# [W] [P] [S] [M] [H] [N] [F]     [L]
# [R] [H] [T] [D] [L] [D] [D] [B] [W]
# [T] [C] [L] [H] [Q] [J] [B] [T] [N]
# [G] [G] [C] [J] [P] [P] [Z] [R] [H]
#  1   2   3   4   5   6   7   8   9 
#
infile = File.open('input.txt').read
stacks = [
  nil, 
  %w(G T R W),
  %w(G C H P M S V W),
  %w(C L T S G M),
  %w(J H D M W R F),
  %w(P Q L H S W F J),
  %w(P J D N F M S),
  %w(Z B D F G C S J),
  %w(R T B),
  %w(H N W L C)
]

def disp(stx) 
  stx[1..-1].each_with_index do |l, i|
    puts format("%i #{l.join(' ')}", i+1)
  end
end

parse = ->(line) { /move (\d+) from (\d+) to (\d+)/.match(line).to_a[1..-1].map(&:to_i) }

infile.lines.each_with_index do |line, i|
  move, from, to = parse.(line)

  # disp(stacks)
  # puts format("%04i M %2i F %2i T %2i", i, move, from, to)

  mid = []
  move.times do 
    c = stacks[from].pop

    if PART_ONE 
      mid << c
    else
      mid.unshift c
    end
  end
  stacks[to].concat(mid)
end

disp(stacks)
puts stacks[1..-1].map(&:last).join
