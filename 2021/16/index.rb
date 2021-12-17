# https://adventofcode.com/2021/day/16
# --- Day 16: Packet Decoder ---

require 'set'

input = File.open('input.txt').readlines[0].strip

## PART_ONE

# input = "D2FE28" # this packet represents a literal value
# input = "38006F45291200" # here is an operator packet... (0) is the length type ID
# # input = "EE00D40C823060" # here is an operator packet... (1) is the length type ID

# # represents an operator packet (version 4) which contains an operator packet
# # (version 1) which contains an operator packet (version 5) which contains a
# # literal value (version 6); this packet has a version sum of 16.
# input = "8A004A801A8002F478"

# # represents an operator packet (version 3) which contains two sub-packets; each
# # sub-packet is an operator packet that contains two literal values. This packet
# # has a version sum of 12.
# input = "620080001611562C8802118E34"

# # has the same structure as the previous example, but the outermost packet uses
# # a different length type ID. This packet has a version sum of 23.
# input = "C0015000016115A2E0802F182340"

# # is an operator packet that contains an operator packet that contains an
# # operator packet that contains five literal values; it has a version sum of 31.
# input = "A0016C880162017C3686B18A3D4780"

## PART_TWO

# input = "C200B40A82" # finds the sum of 1 and 2, resulting in the value 3
# input = "04005AC33890" # finds the product of 6 and 9, resulting in the value 54.
# input = "880086C3E88112" # finds the minimum of 7, 8, and 9, resulting in the value 7.
# input = "CE00C43D881120" # finds the maximum of 7, 8, and 9, resulting in the value 9.
# input = "D8005AC2A8F0" # produces 1, because 5 is less than 15.
# input = "F600BC2D8F" # produces 0, because 5 is not greater than 15.
# input = "9C005AC2F8F0" # produces 0, because 5 is not equal to 15.
# input = "9C0141080250320F1802104A08" # produces 1, because 1 + 3 = 2 * 2.

def zp(s)
  while s.size < 4
    s = "0#{s}"
  end
  s
end

def to_b(hex)
  hex.chars.map {|c|
    zp(
      c.to_i(16).to_s(2)
    )
  }.join('')
end


TIMES = 100
TRACE = true
PART_ONE = true

def trace(*msg)
  if TRACE || ENV['TRACE'] == '1'
    puts format(*msg.map {|f| %w(Array Hash Set Symbol).include?(f.class.to_s) ? f.inspect : f})
  end
end

def ver(pkt)
  # first 3 bits
  # trace '[ver:%s]', pkt[0,3]
  pkt[0,3].to_i(2)
end

def type_id(pkt)
  # second 3 bits
  # trace '[type_id:%s]', pkt[3,3]
  pkt[3,3].to_i(2)
end

def operator(type_id)
  [
    :sum,
    :product,
    :minimum,
    :maximum,
    :literal,
    :gt,
    :lt,
    :eq
  ][type_id]
end

def operate(type_id, *subs)
  op = operator(type_id)

  trace 'op %s %s', op, subs

  case op
  when :sum
    subs.sum
  when :product
    subs.inject(1) {|memo, obj| memo * obj}
  when :minimum
    subs.min
  when :maximum
    subs.max
  when :gt
    raise "#{op.inspect} wrong size #{subs.size}" if subs.size != 2
    a, b = subs
    a > b ? 1 : 0
  when :lt
    raise "#{op.inspect} wrong size #{subs.size}" if subs.size != 2
    a, b = subs
    a < b ? 1 : 0
  when :eq
    raise "#{op.inspect} wrong size #{subs.size}" if subs.size != 2
    a, b = subs
    a == b ? 1 : 0
  else
    raise "operation error on type_id #{type_id} with values #{subs.inspect}"
  end
end

def decode_literal(pkt)
  start = 6
  lead = pkt[start]
  take = []
  while lead == '1'
    take << pkt[start + 1, 4]
    # trace "start %i: %s", start, take

    start += 5
    lead = pkt[start]
  end

  take << pkt[start + 1, 4]
  # trace "start %i: %s", start, take
  # lead is 0, one last
  final = take.join('').to_i(2)

  [ final, start + 5 ]
end

def decode(pkt, result=[], level=0)
  version = ver(pkt)
  type_id = type_id(pkt)


  trace ''
  trace "decode l:%i t:%s %s", level, operator(type_id), pkt

  if PART_ONE
    result << version
  end

  case type_id
  when 4
    trace "literal value packet returns value"

    ## pull off the literal value packet value until end is reached.
    value, taken = decode_literal(pkt)

    trace 'from: %s', pkt
    trace 'take: %s', pkt[0, taken]
    trace "left: %#{pkt.size}s", pkt[taken, pkt.size]
    trace 'val:  %i', value

    [
      value,
      nil,
      pkt[taken, pkt.size]
    ]
  else
    trace ''
    trace 'operator packet [%s] has packets', type_id
    length_type_id = pkt[6]
    trace ' length_type_id: %s', length_type_id

    case length_type_id
    when '0'
      total_len_part = pkt[7, 15]
      total_len = total_len_part.to_i(2)
      trace ' total_length: %s %s', total_len, total_len_part

      # take packets out of remaining length until total_len is reached
      remaining = pkt[22, pkt.size]
      values = []
      taken = 0

      while taken != total_len && remaining !~ /^0+$/
        trace '  nest!'
        prev = remaining.size
        value, took, remaining = decode(remaining, result, level + 1)

        taken += prev - remaining.size

        values << value
        trace '  back at %i, took %s', level, taken
        #   trace 'value: %s, took: %i', value, took
        #   values << value
        #   taken += took
        #   starting_at += took
        # end
      end

      result = nil
      if values.any? {|v| !v.nil?}
        result = operate(type_id, *values.compact)
        trace '= level %i operation result %i', level, result
      end

      if result.nil?
        raise "ERROR NIL"
      end

      [ result, nil, remaining ]
    when '1'
      sub_packets = pkt[7, 11].to_i(2)
      trace ' sub_packets: %s', sub_packets

      remaining = pkt[18, pkt.size]
      values = []

      sub_packets.times do |n|
        trace '  sub_packets.times %i', n
        value, took, remaining = decode(remaining, result, level + 1)
        trace '  back at %i', level
        values << value
        break if remaining =~ /^0+$/
      end

      result = nil
      if values.any? {|v| !v.nil?}
        result = operate(type_id, *values.compact)
        trace '= level %i operation result %i', level, result
      end

      if result.nil?
        raise "ERROR NIL"
      end

      [ result, nil, remaining ]
    end
  end
end

binput = to_b(input)

trace 'IN:  %s', input
trace 'BIN: %s (%i)', binput, binput.size

result = []
value, _, _ = decode(binput, result)

trace "PART_ONE: result %s (%i)", result, result.sum
trace "PART_TWO: value  %s", value