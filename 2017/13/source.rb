# INPUT FORMAT:
#
#   depth: range
#

input = open('input.txt').readlines().map {|line|
  line.split(':').map(&:strip).map(&:to_i)
}

# input = "0: 3
# 1: 2
# 4: 4
# 6: 4".split("\n").map {|line|
#   line.split(':').map(&:strip).map(&:to_i)
# }

module Part1
  class << self
    def build(input)
      firewall = []

      input.each do |layer|
        if layer[0] > firewall.size
          (layer[0] - firewall.size).times do
            firewall << [0, nil, nil]
          end
        end

        # idx is depth
        # [current_scanner_position, range, direction]
        firewall << [0, layer[1], +1]
      end

      return firewall
    end

    # pretty print
    def repr(depth, firewall)
      firewall.each_with_index do |layer, idx|
        layers = []

        if depth === idx
          if layer[1].nil?
            layers << '(.)'
          else
            if layer[0] === 0
              layers << "(S)"
            else
              layers << "( )"
            end

            (layer[1] - 1).times do |d|
              if (d + 1) === layer[0]
                layers << '[S]'
              else
                layers << '[ ]'
              end
            end
          end
        else
          if layer[1].nil?
            layers << '...'
          else
            (layer[1]).times do |d|
              if d === layer[0]
                layers << '[S]'
              else
                layers << '[ ]'
              end
            end
          end
        end

        puts "%02i %s" % [ idx, layers.join(' ') ]
      end
    end

    # modify firewall in place, advancing all scanners one step
    def step(firewall)
      firewall.each do |layer|
        if layer[1]
          next_layer = layer[0] + layer[2]
          if next_layer === layer[1] || next_layer < 0
            layer[2] *= -1
            next_layer = layer[0] + layer[2]
          end
          layer[0] = next_layer
        end
      end
    end

    def test_run(firewall)
      depth = 0
      captures = []

      # each step:
      # - packet moves
      # - scanners move
      # puts "INIT"
      # repr(-1, firewall)

      while depth < firewall.size

        # check for capture at this depth, calculate severity
        if firewall[depth][1] && firewall[depth][0] === 0
          captures << (depth * firewall[depth][1])
        end

        # move scanners
        step(firewall)

        depth += 1
      end

      severity = captures.sum
      return [ captures, severity ]
    end
  end
end

firewall = Part1.build(input)
caps, severity = Part1.test_run(firewall)
puts "PART ONE CAPTURES: #{caps.inspect}"
puts "PART ONE SEVERITY: #{severity}"
puts "----------------------------"

#
# Part 2 Style:
# - only track scannable layers
# - instead of "back and forth", scan only forwards.
#   - for example, with a stated range of 4 a layer that scans only forwards
#     has an effective range of 6:
#     >1   2   3   4
#     [ ] [ ] [ ] [ ]
#          6   5    <
#
#     >1   2   3   4   5   6
#     [ ] [ ] [ ] [ ] [ ] [ ]
#
#     are equivalent. This means we can use modular math.
# - no stepping the firewall, just use algebra to check whether a layer
#   is in a capturing state for a given delay
# - no representation or step or test_run functions, we don't care
#

module Part2
  class << self
    def build(input)
      firewall = []

      input.each do |layer|
        # [depth, range]
        firewall << [layer[0], layer[1] + (layer[1] - 2)]
      end

      return firewall
    end

    def gets_captured(firewall, delay)
      firewall.each do |layer|
        if (layer[0] + delay) % layer[1] === 0
          return true
        end
      end

      return false
    end
  end
end

firewall = Part2.build(input)
n = 0
captured = Part2.gets_captured(firewall, n)

loop do
  n += 1
  captured = Part2.gets_captured(firewall, n)

  if !captured
    puts "PART 2 ESCAPE AFTER #{n} DELAY!"
    break
  end
end

