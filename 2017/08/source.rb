# --- Day 8: I Heard You Like Registers ---
#
# You receive a signal directly from the CPU. Because of your recent
# assistance with jump instructions, it would like you to compute the result
# of a series of unusual register instructions.
#
# Each instruction consists of several parts: the register to modify, whether
# to increase or decrease that register's value, the amount by which to
# increase or decrease it, and a condition. If the condition fails, skip the
# instruction without modifying the register. The registers all start at 0.
# The instructions look like this:
#
#   b inc 5 if a > 1
#   a inc 1 if b < 5
#   c dec -10 if a >= 1
#   c inc -20 if c == 10
#
# These instructions would be processed as follows:
#
# - Because a starts at 0, it is not greater than 1, and so b is not modified.
# - a is increased by 1 (to 1) because b is less than 5 (it is 0).
# - c is decreased by -10 (to 10) because a is now greater than or equal to 1
#   (it is 1).
# - c is increased by -20 (to -10) because c is equal to 10.
#
# After this process, the largest value in any register is 1.
#
# You might also encounter <= (less than or equal to) or != (not equal to).
# However, the CPU doesn't have the bandwidth to tell you what all the
# registers are named, and leaves that to you to determine.
#
# What is the largest value in any register after completing the instructions
# in your puzzle input?
#
# --- Part Two ---
#
# To be safe, the CPU also needs to know the highest value held in any register
# during this process so that it can decide how much memory to allocate to
# these operations. For example, in the above instructions, the highest value
# ever held was 10 (in register c after the third instruction was evaluated).
#

input = "b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10".split("\n")

input = open('input.txt').readlines()

# instruction is [ COMMAND, CONDITION ]
instructions = []

# returns action performing function
#
def action(str, value)
  lambda { |n|
    # inc is +(value * 1), dec is +(value * -1)
    n + (value * (str === 'inc' ? 1 : -1))
  }
end

# returns condition checking function
def condition(str, other)
  lambda { |value|
    # rely on Ruby's eval capabilities
    value.send(str.to_sym, other)
  }
end

input.each do |line|
  #    $1       $2        $3         $4       $5      $6
  if /([a-z]+) (inc|dec) (-?\d+) if ([a-z]+) ([^ ]+) (-?\d+)/ =~ line
    instructions << [
      # command is [ register, action returning value ]
      [ $1, action($2, $3.to_i) ],
      # condition is [ register, condition function returning boolean ]
      [ $4, condition($5, $6.to_i)]
    ]
  else
    puts "UNPROCESSED LINE: #{line}"
  end
end

registers = {}
max_overall = nil

instructions.each_with_index do |instruction, idx|
  # check condition, perform action
  cond = instruction[1]
  act  = instruction[0]

  # treat unset registers as 0
  if cond[1].call(registers[cond[0]] || 0)
    puts "PERFORM INSTRUCTION #{idx}"
    registers[act[0]] = act[1].call(registers[act[0]] || 0)

    current_max = registers.values.max
    if max_overall.nil? || current_max > max_overall
      max_overall = current_max
    end
  end
end

puts registers.inspect
puts "LARGEST FINAL VALUE:      #{registers.values.max}"
puts "LARGEST IN-PROCESS VALUE: #{max_overall}"
