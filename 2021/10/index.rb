# https://adventofcode.com/2021/day/10

input = File.open('input.txt').readlines.map(&:strip)
# input = [
#   '{([(<{}[<>[]}>{[]{[(<()>'
# ]

TRACE = true
PART_ONE = true
PART_TWO = true

def trace(*msg)
  puts format(*msg) if TRACE || ENV['TRACE'] == '1'
end

class Stack
  CLOSERS = { ']' => '[', '}' => '{', ')' => '(', '>' => '<' }
  CLOSE_SCORE = {
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4,
  }
  COMPLETERS = { '[' => ']', '{' => '}', '(' => ')', '<' => '>' }

  def initialize
    @a = []
  end

  def <<(sym)
    # trace sym
    if CLOSERS[sym]
      if legal?(sym)
        out = @a.pop
        # trace '  >> %s', sym
      else
        # trace 'failure on %s', sym
        return false
      end
    else
      # trace '<< %s', sym
      @a.push sym
    end

    # trace '  %s', @a.join
    true
  end

  def complete
    @a.reverse.map { |sym| COMPLETERS[sym] }
  end

  def score
    complete.inject(0) do |memo, sym|
      (memo * 5) + CLOSE_SCORE[sym]
    end
  end

  def legal?(sym)
    @a.last == CLOSERS[sym]
  end
end

# part 1 scoring
SCORE = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25_137 }

corrupteds = []
incompletes = []

input.each do |line|
  stack = Stack.new
  failed = false
  failed_on = nil

  line.chars.each do |c|
    if stack << c
      next
    else
      failed = true
      failed_on = c
    end

    break if failed
  end

  if failed
    corrupteds << [line, failed_on]
  elsif PART_TWO
    trace 'complete: %s - %i', stack.complete.join, stack.score
    incompletes << stack.score
  end

  stack = Stack.new
end

if PART_ONE
  puts format('%i corrupted', corrupteds.size)
  puts format('PART_ONE: %i', corrupteds.map { |(_, sym)| SCORE[sym] }.sum)
end

if PART_TWO
  puts format('%i incomplete', incompletes.size)
  puts format('PART_TWO: %i', incompletes.sort[incompletes.size / 2])
end
