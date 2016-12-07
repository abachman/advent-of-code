# --- Day 7: Internet Protocol Version 7 ---
#
# While snooping around the local network of EBHQ, you compile a list of IP
# addresses (they're IPv7, of course; IPv6 is much too limited). You'd like to
# figure out which IPs support TLS (transport-layer snooping).
#
# An IP supports TLS if it has an Autonomous Bridge Bypass Annotation, or ABBA.
# An ABBA is any four-character sequence which consists of a pair of two
# different characters followed by the reverse of that pair, such as xyyx or
# abba. However, the IP also must not have an ABBA within any hypernet
# sequences, which are contained by square brackets.
#
# For example:
#
# - abba[mnop]qrst supports TLS (abba outside square brackets).
# - abcd[bddb]xyyx does not support TLS (bddb is within square brackets, even
#   though xyyx is outside square brackets).
# - aaaa[qwer]tyui does not support TLS (aaaa is invalid; the interior
#   characters must be different).
# - ioxxoj[asdfgh]zxcvbn supports TLS (oxxo is outside square brackets, even
#   though it's within a larger string).
#
# How many IPs in your puzzle input support TLS?
#
# --- Part Two ---
#
# You would also like to know which IPs support SSL (super-secret listening).
#
# An IP supports SSL if it has an Area-Broadcast Accessor, or ABA, anywhere in
# the supernet sequences (outside any square bracketed sections), and a
# corresponding Byte Allocation Block, or BAB, anywhere in the hypernet
# sequences. An ABA is any three-character sequence which consists of the same
# character twice with a different character between them, such as xyx or aba.
# A corresponding BAB is the same characters but in reversed positions: yxy and
# bab, respectively.
#
# For example:
#
# - aba[bab]xyz supports SSL (aba outside square brackets with corresponding
#   bab within square brackets).
# - xyx[xyx]xyx does not support SSL (xyx, but no corresponding yxy).
# - aaa[kek]eke supports SSL (eke in supernet with corresponding kek in
#   hypernet; the aaa sequence is not related, because the interior character
#   must be different).
# - zazbz[bzb]cdb supports SSL (zaz has no corresponding aza, but zbz has a
#   corresponding bzb, even though zaz and zbz overlap).
#
# How many IPs in your puzzle input support SSL?
#
#

VERBOSE = false
def log(msg)
  puts msg if VERBOSE
end

PART_ONE = false
INPUT = open('input.txt').readlines()
# INPUT = %w(abba[mnop]qrst abcd[bddb]xyyx aaaa[qwer]tyui ioxxoj[asdfgh]zxcvbn asdf[efojfeoj]eeokfe[qpod]tootleske)
# INPUT = %w(aba[bab]xyz xyx[xyx]xyx aaa[kek]eke zazbz[bzb]cdb)

def has_abba?(str)
  log "  has_abba?(#{ str })"
  (str.size - 3).times do |idx|
    log "    CHECK #{ str[idx, 4].split('').inspect }"
    a, b, c, d = str[idx, 4].split('')
    if a != b && a == d && b == c
      log "    GOT"
      return true
    end
  end
  log "    FAIL"
  return false
end

def abas(str)
  # return ABA sequences from str
  seqs = []
  log "  abas(#{str})"
  (str.size - 2).times do |idx|
    a, b, c = str[idx, 3].split('')
    log "    CHECK #{ str[idx, 3] }"
    if a != b && a == c
      log "    GOT"
      seqs << a + b + c
    end
  end
  return seqs
end

has_tls = []
has_ssl = []

INPUT.each do |addr|
  outs = []
  oi = 0
  ins  = []
  ii = 0
  outer = true

  addr.each_char do |c|
    if c == '['
      outer = false
      ins << ''
      next
    elsif c == ']'
      outer = true
      outs << ''
      next
    end

    if outer
      outs << '' if outs.size == 0
      outs.last << c
    else
      ins.last << c
    end
  end

  log "ADDR: #{ addr }"
  log "  OUTS #{ outs } INS #{ ins.inspect } "

  if outs.any? {|part| has_abba?(part)} && !ins.any? {|part| has_abba?(part)}
    has_tls << addr
    log "TLS: #{addr}"
  end

  seqs = outs.inject([]) {|memo, obj| memo << abas(obj); memo}.flatten
  log "  SEQS #{ seqs.inspect } FROM #{ outs.inspect }"
  seqs.each do |seq|
    bab = seq[1] + seq[0] + seq[1]
    if ins.any? {|s| s.include?(bab)}
      log "  ! SSL #{ bab } IN #{ins.inspect}"
      has_ssl << addr
      break # on first match
    end
  end

end

puts "#{ has_tls.size } HAVE TLS" # 115
puts "#{ has_ssl.size } HAVE SSL" # 231
# puts has_ssl
