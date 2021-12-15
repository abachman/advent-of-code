class Element
  attr_accessor :value, :score

  def initialize(value, score)
    @value = value
    @score = score
  end

  def to_s
    "<#Element @value=#{value} @score=#{score}>"
  end

  def <=>(other)
    score <=> other.score
  end

  def >=(other)
    other.score >= score
  end

  def >(other)
    other.score > score
  end

  def eql?(other)
    value == other.value
  end

  def ==(other)
    hash == other.hash
  end

  def hash
    value.hash
  end
end

if __FILE__ == $0
  require 'set'

  m = SortedSet.new
  o = Set.new

  a = Element.new([0, 0], 1)
  b = Element.new([0, 1], 2)
  c = Element.new([1, 0], 3)
  d = Element.new([0, 0], 4)

  puts "SortedSet"
  puts 'a'
  m << a
  puts 'b'
  m << b
  puts 'c'
  m << c
  puts 'd'
  m << d

  puts "Set"
  o << a
  o << b
  o << c
  o << d

  puts "a == b #{(a <=> b).inspect}"
  puts "a == d #{(a <=> d).inspect}"

  puts "SortedSet"
  m.each do |el|
    puts el.score
  end

  puts "Set"
  o.each do |el|
    puts el.score
  end

  puts "SortedSet -> Set"
  Set.new(m).each do |el|
    puts el.score
  end
end
