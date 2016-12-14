# --- Day 10: Balance Bots ---
#
# You come upon a factory in which many robots are zooming around handing small
# microchips to each other.
#
# Upon closer examination, you notice that each bot only proceeds when it has
# two microchips, and once it does, it gives each one to a different bot or
# puts it in a marked "output" bin. Sometimes, bots take microchips from
# "input" bins, too.
#
# Inspecting one of the microchips, it seems like they each contain a single
# number; the bots must use some logic to decide what to do with each chip. You
# access the local control computer and download the bots' instructions (your
# puzzle input).
#
# Some of the instructions specify that a specific-valued microchip should be
# given to a specific bot; the rest of the instructions indicate what a given
# bot should do with its lower-value or higher-value chip.
#
# For example, consider the following instructions:
#
#     value 5 goes to bot 2
#     bot 2 gives low to bot 1 and high to bot 0
#     value 3 goes to bot 1
#     bot 1 gives low to output 1 and high to bot 0
#     bot 0 gives low to output 2 and high to output 0
#     value 2 goes to bot 2
#
# Kinds of instructions:
# - where chips go first: "value ..."
# - what happens when a particular bot gets 2 chips: "bot ..."
#
# Facts about bots:
# - they have a number
# - they can hold two chips
# - they do something with chips when they have two
#
#
#     BOTS     0    1    2
#     CHIPS    3,5
#
#     OUTPUTS  0    1    2
#     CHIPS    5    2    3
#
#
# - Initially, bot 1 starts with a value-3 chip, and bot 2 starts with a
#   value-2 chip and a value-5 chip.
# - Because bot 2 has two microchips, it gives its lower one (2) to bot 1 and
#   its higher one (5) to bot 0.
# - Then, bot 1 has two microchips; it puts the value-2 chip in output 1 and
#   gives the value-3 chip to bot 0.
# - Finally, bot 0 has two microchips; it puts the 3 in output 2 and the 5 in
#   output 0.
#
# In the end, output bin 0 contains a value-5 microchip, output bin 1 contains
# a value-2 microchip, and output bin 2 contains a value-3 microchip. In this
# configuration, bot number 2 is responsible for comparing value-5 microchips
# with value-2 microchips.
#
# Based on your instructions, what is the number of the bot that is responsible
# for comparing value-61 microchips with value-17 microchips?
#
# --- Part Two ---
#
# What do you get if you multiply together the values of one chip in each of
# outputs 0, 1, and 2?
#
#

INPUT = open('input.txt').readlines()
# INPUT = %[value 5 goes to bot 2
# bot 2 gives low to bot 1 and high to bot 0
# value 3 goes to bot 1
# bot 1 gives low to output 1 and high to bot 0
# bot 0 gives low to output 2 and high to output 0
# value 2 goes to bot 2].split("\n")

def parse_instruction(inst)
  matched = /(low|high) to (bot|output) (\d+)/.match(inst)

  return {
    value_comparison: matched[1],
    target_type: matched[2],
    target_id: matched[3].to_i
  }
end

def new_bot(id)
  {
    id: id,
    commands: {low: {id: nil, type: nil},
               high: {id: nil, type: nil}},
    values: []
  }
end

def send_value_to_bot(value, bot_id, bots)
  bot = bots[bot_id] ||= new_bot(bot_id)
  bot[:values] << value
  bot[:values].sort!
end

def send_value_to_output(value, o_id, outputs)
  output = outputs[o_id] ||= []
  output << value
end

# bots = {
#   id: {commands: {low: $command, high: $command}, values: [a, b], id: number },
#   ...
# }
bots = {}

# outputs = {
#   id: [values]
# }
outputs = {}

INPUT.each do |line|
  if /^value (\d+) [^b]+bot (\d+)/ =~ line
    # $VALUE goes to $BOT

    bot_identifier = $2.to_i
    value = $1.to_i

    send_value_to_bot(value, bot_identifier, bots)

  elsif /^bot (\d+) gives (.+) and (.+)$/ =~ line
    # A command looks like this:
    # $BOT    gives    $INSTRUCTION       and    $INSTRUCTION
    #
    # An INSTRUCTION looks like this:
    # $VALUE_BY_COMPARISON to $BOT_OR_OUTPUT

    bot_identifier = $1.to_i
    instructions = [$2, $3].map {|i| parse_instruction(i)}

    bot = bots[bot_identifier]
    if bot.nil?
      bot = new_bot(bot_identifier)
      bots[bot_identifier] = bot
    end

    bot[:commands][:low]  = instructions.find {|i| i[:value_comparison] == 'low'}
    bot[:commands][:high] = instructions.find {|i| i[:value_comparison] == 'high'}
  end
end

def send_value_by_command(value, command, bots, outputs)
  if command[:target_type] == 'bot'
    send_value_to_bot(value, command[:target_id], bots)
  else
    send_value_to_output(value, command[:target_id], outputs)
  end
end

count = 1

#   A Bot is:
#   {
#     commands: {
#       low: $command,
#       high: $command
#     },
#     values: [a, b],
#     id: number
#   }
ready_bots = bots.values.select {|b| b[:values].size == 2}

while ready_bots.size > 0
  puts "ROUND #{ count }, #{ ready_bots.size } BOTS READY FOR WORK"

  ready_bots.each do |bot|
    puts "  BOT #{ bot[:id] } HAS VALUES #{ bot[:values].inspect }"
    if bot[:values].include?(17) && bot[:values].include?(61)
      puts "------------------------------------------------"
      puts "!!! BOT #{ bot[:id] } HAS 17 AND 61"
      puts "------------------------------------------------"
    end

    # empty values
    low, high = bot[:values]
    bot[:values] = []

    send_value_by_command(low, bot[:commands][:low], bots, outputs)
    send_value_by_command(high, bot[:commands][:high], bots, outputs)
  end

  ready_bots = bots.values.select {|b| b[:values].size == 2}

  count += 1
end

puts "---"
puts
puts "FINAL OUTPUTS"
puts
# puts bots.inspect
puts outputs.keys.sort.map {|k| "%3i  %s" % [k, outputs[k].map(&:to_s).join(' ')]}

