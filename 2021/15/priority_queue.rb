class PriorityQueue
  attr_reader :elements

  def initialize
    @elements = [nil]
  end

  def <<(element)
    @elements << element
    bubble_up(@elements.size - 1)
  end

  def pop
    exchange(1, @elements.size - 1)
    max = @elements.pop
    bubble_down(1)
    max
  end

  # obj has a new weight, remove it from @elements and resort
  def upsert(obj)
    idx = index_of(obj)

    if idx && idx > -1
      # move idx'd item to end of list
      exchange(idx, @elements.size - 1)
      # drop it
      @elements.pop
      # readjust heap
      bubble_down(idx)
    end

    self << obj
  end

  def size
    @elements.size - 1
  end

  private

  def index_of(obj)
    # get idx of obj in heap
    @elements.find_index(obj)
  end

  def bubble_up(index)
    parent_index = (index / 2)

    return if index <= 1
    return if @elements[parent_index] >= @elements[index]

    exchange(index, parent_index)
    bubble_up(parent_index)
  end

  def bubble_down(index)
    child_index = (index * 2)

    return if child_index > @elements.size - 1

    not_the_last_element = child_index < @elements.size - 1
    left_element = @elements[child_index]
    right_element = @elements[child_index + 1]
    child_index += 1 if not_the_last_element && right_element > left_element

    return if @elements[index] >= @elements[child_index]

    exchange(index, child_index)
    bubble_down(child_index)
  end

  def exchange(source, target)
    @elements[source], @elements[target] = @elements[target], @elements[source]
  end
end

if __FILE__ == $0
  require_relative './element'

  q = PriorityQueue.new

  q << Element.new([0, 0], 3)
  q << Element.new([0, 1], 4)
  q << Element.new([1, 1], 9)
  q << Element.new([0, 2], 2)
  q << Element.new([9, 2], 2)

  q.upsert Element.new([1, 1], 1)
  q.upsert Element.new([1, 2], 1)
  q.upsert Element.new([0, 0], 0)
  q.upsert Element.new([9, 2], 8)

  n = 0
  while q.size > 0
    a = q.pop
    puts "#{n}: #{a}"
    n += 1
  end
end