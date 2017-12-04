PART_ONE = false
input = open('input.txt').readlines().map {|line|
  line.split(' ').map(&:to_i)
}

if PART_ONE
  # input = "5 1 9 5
  # 7 5 3
  # 2 4 6 8".lines.map {|l| l.split(' ').map(&:to_i)}
  #
  # input.each do |line|
  #   puts line.inspect
  # end

  sum = 0

  input.each do |line|
    mn, mx = nil, nil
    line.each do |n|
      if mn.nil? || n < mn
        mn = n
      end

      if mx.nil? || n > mx
        mx = n
      end
    end
    sum += mx - mn
  end

  puts "PART 1 SUM #{ sum }"
else
  ## Part 2

  # input = "5 9 2 8
  # 9 4 7 3
  # 3 8 6 5".lines.map {|l| l.split(' ').map(&:to_i)}

  def find_division_pair(line)
    line.each do |n|
      line.each do |other|
        next if n === other

        if n < other && other % n === 0
          # evenly divides other
          return n, other
        elsif n > other && n % other === 0
          return other, n
        end
      end
    end
  end

  sum = 0

  input.each do |line|
    mn, mx = find_division_pair(line)
    sum += mx / mn
  end

  puts "PART 2 SUM #{ sum }"
end
