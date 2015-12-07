# --- Day 7: Some Assembly Required ---
#
# This year, Santa brought little Bobby Tables a set of wires and bitwise logic
# gates! Unfortunately, little Bobby is a little under the recommended age range,
# and he needs help assembling the circuit.
#
# Each wire has an identifier (some lowercase letters) and can carry a 16-bit
# signal (a number from 0 to 65535). A signal is provided to each wire by a gate,
# another wire, or some specific value. Each wire can only get a signal from
# one source, but can provide its signal to multiple destinations. A gate
# provides no signal until all of its inputs have a signal.
#
# The included instructions booklet describe how to connect the parts together: x
# AND y -> z means to connect wires x and y to an AND gate, and then connect its
# output to wire z.
#
# For example:
#
# - 123 -> x means that the signal 123 is provided to wire x.
# - x AND y -> z means that the bitwise AND of wire x and wire y is provided to
#   wire z.
# - p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and
#   then provided to wire q.
# - NOT e -> f means that the bitwise complement of the value from wire e is
#   provided to wire f.
# - Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If,
#   for some reason, you'd like to emulate the circuit instead, almost all
#   programming languages (for example, C, JavaScript, or Python) provide operators
#   for these gates.
#
# For example, here is a simple circuit:
#
#     123 -> x
#     456 -> y
#     x AND y -> d
#     x OR y -> e
#     x LSHIFT 2 -> f
#     y RSHIFT 2 -> g
#     NOT x -> h
#     NOT y -> i
#
# After it is run, these are the signals on the wires:
#
#     d: 72
#     e: 507
#     f: 492
#     g: 114
#     h: 65412
#     i: 65079
#     x: 123
#     y: 456
#
# In little Bobby's kit's instructions booklet (provided as your puzzle input),
# what signal is ultimately provided to wire a?
#

in_file = open('input.txt').readlines

# name is the label for this Wire, outputs are gates or or other wires, input is a
Wire = Struct.new(:name, :value) do
  def ready?
    !value.nil?
  end

  def result
    "%4s:%12i" % [name, value]
  end

  def receive(val)
    self.value = val
  end

  def reset
    self.value = nil
  end
end

class Value
  def initialize(number)
    @number = number.to_i
  end

  def ~
    Value.new(("%016i" % [@number.to_s(2)]).each_char.map {|c| c == '0' ? '1' : '0'}.join.to_i(2))
  end

  def |(other)
    Value.new(@number | other.to_i)
  end

  def &(other)
    Value.new(@number & other.to_i)
  end

  def <<(other)
    Value.new(@number << other.to_i)
  end

  def >>(other)
    Value.new(@number >> other.to_i)
  end

  def %(other)
    Value.new(@number % other.to_i)
  end

  def ready?
    true
  end

  def value
    self
  end

  def to_i
    @number
  end
end

# inputs is a list of one or more Wires, output is a Wire, type is the type of gate [AND OR LSHIFT RSHIFT NOT],
# evaluate calculates the final value of the inputs after running the logic and sends it to the output
Gate = Struct.new(:type, :inputs, :output, :value) do
  def ready?
    left, right = [inputs[0], inputs[1]]

    case type
    when :not, :pass
      # only care about left
      left.ready?
    else
      left.ready? && right.ready?
    end
  end

  def reset
    self.value = nil
  end

  def complete?
    !value.nil?
  end

  def evaluate
    self.value = case type
                 when :not
                   # inputs is [Wire]
                   # make sure we get the proper 16-bit complement, not the complement of the full Fixnum
                   ~(inputs[0].value)
                 when :and
                   # inputs are [Wire, Wire]
                   inputs[0].value & inputs[1].value
                 when :or
                   # inputs are [Wire, Wire]
                   inputs[0].value | inputs[1].value
                 when :lshift
                   # inputs are [Wire, Value]
                   inputs[0].value << inputs[1].value
                 when :rshift
                   # inputs are [Wire, Value]
                   inputs[0].value >> inputs[1].value
                 when :pass
                   inputs[0].value
                 end

    self.value = value % 65535

    # send value to output Wire
    output.receive(value)
  end
end

wires = {}
gates = []

# returns Gate or Integer
def parse_instruction(ins)
  if /^\d+$/ =~ ins
    # is value
    return ins.to_i
  else
    # is gate, figure out type
    gate = if /NOT ([a-z0-9]+)/ =~ ins
             Gate.new(:not, [$1])
           elsif /([a-z0-9]+) AND ([a-z0-9]+)/ =~ ins
             Gate.new(:and, [$1, $2])
           elsif /([a-z0-9]+) OR ([a-z0-9]+)/ =~ ins
             Gate.new(:or, [$1, $2])
           elsif /([a-z0-9]+) LSHIFT (\d+)/ =~ ins
             Gate.new(:lshift, [$1, $2])
           elsif /([a-z0-9]+) RSHIFT (\d+)/ =~ ins
             Gate.new(:rshift, [$1, $2])
           elsif /^([a-z0-9]+)$/ =~ ins
             Gate.new(:pass, [$1])
           end
  end
end

## TEST

# in_file = [
#   '123 -> x',
#   '456 -> y',
#   'x AND y -> d',
#   'x OR y -> e',
#   'x LSHIFT 2 -> f',
#   'y RSHIFT 2 -> g',
#   'NOT x -> h',
#   'NOT y -> i',
# ]

def get_wire(name, wires)
  if /[a-z]+/ =~ name
    out_wire = wires[name]
    if out_wire.nil?
      out_wire = Wire.new(name, nil)
      wires[name] = out_wire
    else
      out_wire
    end
  elsif /\d+/ =~ name
    Value.new(name.to_i)
  end
end

def initialize_circuit(in_file, wires, gates)
  instruction_count = 0
  in_file.each do |line|
    _, left, right = /^(.+) -> ([a-z]+)$/.match(line).to_a
    wire_name = right.strip
    out_wire = get_wire(wire_name, wires)
    instruction = parse_instruction(left.strip)
    instruction_count += 1

    case instruction.class.to_s
    when 'Fixnum'
      value = Value.new(instruction)
      puts "INSTRUCTION #{ instruction_count } IS VALUE #{ value } ON WIRE #{ out_wire.name }"
      out_wire.receive(value)
    when 'Gate'
      gate = instruction

      # connect gate to output
      gate.output = out_wire
      # convert inputs from names to Wires / Values
      gate.inputs = case gate.type
                    when :not, :pass
                      # inputs is [Wire]
                      [get_wire(gate.inputs[0], wires)]
                    when :and, :or, :lshift, :rshift
                      [get_wire(gate.inputs[0], wires), get_wire(gate.inputs[1], wires)]
                    end

      gates << gate
      puts "INSTRUCTION #{ instruction_count } IS #{ gate.type } GATE WITH INPUTS #{ gate.inputs }"
    else
      raise "UNRECOGNIZED INSTRUCTION: #{ left } -> #{ right }"
    end
  end
end

## Part One

puts "------- PART ONE -------"

initialize_circuit(in_file, wires, gates)

passes = 0
until gates.all? {|gate| gate.complete?}
  evals = 0

  gates.each do |gate|
    if gate.ready? && !gate.complete?
      gate.evaluate
      evals += 1
    end
  end

  passes += 1

  puts "PASS #{ passes }, EVALS #{ evals }"

  break if evals == 0
end

puts
puts "RESULT #{ wires['a'].result }"
puts

puts "------- PART TWO -------"

## Part Two
#
# Now, take the signal you got on wire a, override wire b to that signal, and
# reset the other wires (including wire a). What new signal is ultimately
# provided to wire a?
#

# "take the signal you got on wire a"
hold_value = wires['a'].value

# "reset other wires" by resetting the circuit
wires = {}
gates = []

initialize_circuit(in_file, wires, gates)

# "override wire b to that signal"
wires['b'].value = hold_value

passes = 0
until gates.all? {|gate| gate.complete?}
  evals = 0

  gates.each do |gate|
    if gate.ready? && !gate.complete?
      gate.evaluate
      evals += 1
    end
  end

  passes += 1

  puts "PASS #{ passes }, EVALS #{ evals }"

  break if evals == 0
end

puts
puts "RESULT #{ wires['a'].result }"
puts

# show everything
# wires.keys.sort.each do |name|
#   puts wires[name].result
# end


