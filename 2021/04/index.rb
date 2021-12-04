input = File.open('input.txt').readlines.map(&:strip)

PART_ONE = false
PART_TWO = true
TRACE = true

def trace(msg, *args)
  if TRACE || ENV['TRACE'] == '1'
    if args && args.size > 0
      puts format(msg, *args)
    else
      puts msg
    end
  end
end

def pboard(board)
  tmpl = (["%4s"] * board[0].size).join(' ')
  board.each do |row|
    trace(tmpl, *row.map {|(n, bool)| bool ? "#{n}*" : "#{n} "})
  end
end

def to_board(lines)
  lines.map do |line|
    line.split(/ +/).map {|n| [n.strip, false]}
  end
end

# returns boards
def parse(lines)
  boards = []
  curr = []

  lines.each do |line|
    if line == ''
      if curr.size > 0
        boards << to_board(curr)
        curr = []
      end
    else
      curr << line
    end
  end

  if curr.size > 0
    boards << to_board(curr)
  end

  boards
end

def mark(board, n)
  # trace 'mark %s', n
  board.each do |row|
    row.each do |col|
      if col[0] == n
        col[1] = true
      end
    end
  end
end

# a = [
#   [ [1, true], [2, false], [3, true] ],
#   [ [1, true], [2, true], [3, true] ],
#   [ [1, false], [2, true], [3, false] ]
# ]
# b = [
#   [ [1, true], [2, false], [3, true] ],
#   [ [1, true], [2, false], [3, false] ],
#   [ [1, true], [2, false], [3, true] ]
# ]
# c = [
#   [ [1, true], [2, false], [3, true] ],
#   [ [1, true], [2, false], [3, false] ],
#   [ [1, false], [2, false], [3, true] ]
# ]
#
# trace evaluate(a).inspect
# trace evaluate(b).inspect
# trace evaluate(c).inspect
def evaluate(board)
  # by row
  success = false
  board.each do |row|
    success ||= row.all? {|(n, bool)| bool}
  end
  return true if success

  # by column
  (0..(board[0].size - 1)).each do |col_idx|
    success ||= board.all? {|row|
      row[col_idx][1]
    }
  end

  success
end

def unmarked(board)
  vals = []
  board.each do |row|
    row.select {|(_, bool)| !bool}.each {|(n, _)| vals << n.to_i}
  end
  vals
end

first = input[0]
rest  = input[1..-1]

calls = first.split(',')
boards = parse(rest)

# trace unmarked(c).inspect
# trace unmarked(c).sum

bingo = false
calls.each do |pick|
  trace 'pick %s', pick

  if boards.size == 0
    trace 'done!'
    break
  end

  boards = boards.map do |board|
    mark(board, pick)
  end

  winners = []
  boards.each_with_index do |board, idx|
    # trace 'board: %s', board.inspect
    if evaluate(board)
      bingo = true

      if PART_ONE
        usum = unmarked(board).sum
        trace 'PART_ONE bingo! pick: %i, unmarked sum: %i, answer: %i', pick, usum, usum * pick.to_i
        pboard(board)
      end

      winners << idx
      if PART_ONE
        break
      end
    end
  end

  if PART_TWO && winners.size > 0
    trace 'drop %i on pick %i (%i)', winners.size, pick, boards.size
    if boards.size == 1
      usum = unmarked(boards[0]).sum
      trace 'PART_TWO bingo! pick: %i, unmarked sum: %i, answer: %i', pick, usum, usum * pick.to_i
      pboard(boards[0])
    end
    winners.reverse.each { |idx|
      trace 'dropping %i', idx
      boards.delete_at(idx)
    }
  end

  if PART_ONE
    break if bingo
  end
end

# require 'json'
# trace calls.inspect
# trace JSON.pretty_generate(boards[0])
