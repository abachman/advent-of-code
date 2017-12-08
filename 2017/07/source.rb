# --- Day 7: Recursive Circus ---
#
# Wandering further through the circuits of the computer, you come upon a tower
# of programs that have gotten themselves into a bit of trouble. A recursive
# algorithm has gotten out of hand, and now they're balanced precariously in a
# large tower.
#
# One program at the bottom supports the entire tower. It's holding a large
# disc, and on the disc are balanced several more sub-towers. At the bottom of
# these sub-towers, standing on the bottom disc, are other programs, each
# holding their own disc, and so on. At the very tops of these
# sub-sub-sub-...-towers, many programs stand simply keeping the disc below
# them balanced but with no disc of their own.
#
# You offer to help, but first you need to understand the structure of these
# towers. You ask each program to yell out their name, their weight, and (if
# they're holding a disc) the names of the programs immediately above them
# balancing on that disc. You write this information down (your puzzle input).
# Unfortunately, in their panic, they don't do this in an orderly fashion; by
# the time you're done, you're not sure which program gave which information.
#
# For example, if your list is the following:
#
#   pbga (66)
#   xhth (57)
#   ebii (61)
#   havc (66)
#   ktlj (57)
#   fwft (72) -> ktlj, cntj, xhth
#   qoyq (66)
#   padx (45) -> pbga, havc, qoyq
#   tknk (41) -> ugml, padx, fwft
#   jptl (61)
#   ugml (68) -> gyxo, ebii, jptl
#   gyxo (61)
#   cntj (57)
#
# ...then you would be able to recreate the structure of the towers that looks
# like this:
#
#                   gyxo
#                 /
#            ugml - ebii
#          /      \
#         |         jptl
#         |
#         |         pbga
#        /        /
#   tknk --- padx - havc
#        \        \
#         |         qoyq
#         |
#         |         ktlj
#          \      /
#            fwft - cntj
#                 \
#                   xhth
#
# In this example, tknk is at the bottom of the tower (the bottom program), and
# is holding up ugml, padx, and fwft. Those programs are, in turn, holding up
# other programs; in this example, none of those programs are holding up any
# other programs, and are all the tops of their own towers. (The actual tower
# balancing in front of you is much larger.)
#
# Before you're ready to help them, you need to make sure your information is
# correct. What is the name of the bottom program?
#
#--- Part Two ---
#
# The programs explain the situation: they can't get down. Rather, they could
# get down, if they weren't expending all of their energy trying to keep the
# tower balanced. Apparently, one program has the wrong weight, and until it's
# fixed, they're stuck here.
#
# For any program holding a disc, each program standing on that disc forms a
# sub-tower. Each of those sub-towers are supposed to be the same weight, or
# the disc itself isn't balanced. The weight of a tower is the sum of the
# weights of the programs in that tower.
#
# In the example above, this means that for ugml's disc to be balanced, gyxo,
# ebii, and jptl must all have the same weight, and they do: 61.
#
# However, for tknk to be balanced, each of the programs standing on its disc
# and all programs above it must each match. This means that the following sums
# must all be the same:
#
#   ugml + (gyxo + ebii + jptl) = 68 + (61 + 61 + 61) = 251
#
#   ugml + (gyxo + ebii + jptl) = 60 + (61 + 61 + 61) = 243
#                                 ^^
#   padx + (pbga + havc + qoyq) = 45 + (66 + 66 + 66) = 243
#   fwft + (ktlj + cntj + xhth) = 72 + (57 + 57 + 57) = 243
#
# As you can see, tknk's disc is unbalanced: ugml's stack is heavier than the
# other two. Even though the nodes above ugml are balanced, ugml itself is too
# heavy: it needs to be 8 units lighter for its stack to weigh 243 and keep the
# towers balanced. If this change were made, its weight would be 60.
#
# Given that exactly one program is the wrong weight, what would its weight
# need to be to balance the entire tower?
#

input = "
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
"

input = open('input.txt').read()

progs = []

input.split("\n").each do |line|
  if /^([a-z]+) \((\d+)\)( -> .+)?/ =~ line
    prog = [$1.strip, $2.strip.to_i]

    if !$3.nil?
      prog << $3.sub(' -> ','').split(',').map(&:strip)
    end

    progs << prog
  end
end

is_child = {}

# get tree of [ weight, [children] ]
def get_weight_tree(tower, prog_name)
  program = tower.find {|p|
    p[0] === prog_name
  }
  # program is [ name, weight, [children] ]

  weight = program[1]

  if program.size === 3
    child_weights = []

    program[2].each do |child|
      child_weights << get_weight_tree(tower, child)
    end

    [ weight, child_weights ]
  else
    return weight
  end
end

# this method should check balance of children
# tree should be [ weight, [child_trees] ]
def check_weight(tree)
  if tree.is_a?(Numeric)
    return tree
  else
    # list of weights of subtrees
    children = tree[1].map {|child| [check_weight(child), child]}

    bad_child = nil
    good_child = nil
    children.each do |c|
      matching_sibs = children.find_all {|sub_c| c[0] === sub_c[0]}.size
      if matching_sibs === 1 && matching_sibs != children.size
        bad_child = c
        good_child = children.find {|sub_c| c[0] != sub_c[0]}
      end
    end

    if bad_child
      bad_child_weight  = bad_child[0]
      good_child_weight = good_child[0]
      bad_child_subtree = bad_child[1]
      puts "UNBALANCED!"
      # puts "  bad weight    #{bad_child_weight}"
      # puts "  good weight   #{good_child[0]}"
      # puts "  bad subtree   #{bad_child_subtree}"
      # puts "  bad self      #{bad_child_subtree[0]}"
      # puts "  bad children  #{bad_child_subtree[1]}"
      # puts "  bad is off by #{bad_child_weight - good_child_weight}"
      puts "  should be #{bad_child_subtree[0] - (bad_child_weight - good_child_weight)}"
      raise "UNBALANCED"
    end

    tree[0] + children.map(&:first).sum
  end
end

# PART 1: search for a program that is not a child

progs.each do |prog|
  if prog.size === 3
    prog[2].each do |p_name|
      # add child names
      is_child[p_name] = true
    end
  end
end

puts "PART 1 ROOT"
puts "  -> #{ progs.map(&:first) - is_child.keys }"

# PART 2: are children balanced? If not, which child is at fault?
puts "PART 2 UNBALANCED SUBTREES"
progs.each do |program|
  tree = get_weight_tree(progs, program[0])
  begin
    check_weight(tree)
  rescue => ex
    puts "  ON #{program[0]}"
  end
end
