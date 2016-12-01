# --- Day 15: Science for Hungry People ---
#
# Today, you set out on the task of perfecting your milk-dunking cookie recipe.
# All you have to do is find the right balance of ingredients.
#
# Your recipe leaves room for exactly 100 teaspoons of ingredients. You make a
# list of the remaining ingredients you could use to finish the recipe (your
# puzzle input) and their properties per teaspoon:
#
# - capacity (how well it helps the cookie absorb milk)
# - durability (how well it keeps the cookie intact when full of milk)
# - flavor (how tasty it makes the cookie)
# - texture (how it improves the feel of the cookie)
# - calories (how many calories it adds to the cookie)
#
# You can only measure ingredients in whole-teaspoon amounts accurately, and
# you have to be accurate so you can reproduce your results in the future. The
# total score of a cookie can be found by adding up each of the properties
# (negative totals become 0) and then multiplying together everything except
# calories.
#
# For instance, suppose you have these two ingredients:
#
#   Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
#   Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
#
# Then, choosing to use 44 teaspoons of butterscotch and 56 teaspoons of
# cinnamon (because the amounts of each ingredient must add up to 100) would
# result in a cookie with the following properties:
#
# - A capacity of 44*-1 + 56*2 = 68
# - A durability of 44*-2 + 56*3 = 80
# - A flavor of 44*6 + 56*-2 = 152
# - A texture of 44*3 + 56*-1 = 76
#
# Multiplying these together (68 * 80 * 152 * 76, ignoring calories for now)
# results in a total score of 62842880, which happens to be the best score
# possible given these ingredients. If any properties had produced a negative
# total, it would have instead become zero, causing the whole score to multiply
# to zero.
#
# Given the ingredients in your kitchen and their properties, what is the total
# score of the highest-scoring cookie you can make?
#
# --- Part Two ---
#
# Your cookie recipe becomes wildly popular! Someone asks if you can make
# another recipe that has exactly 500 calories per cookie (so they can use it
# as a meal replacement). Keep the rest of your award-winning process the same
# (100 teaspoons, same ingredients, same scoring system).
#
# For example, given the ingredients above, if you had instead selected 40
# teaspoons of butterscotch and 60 teaspoons of cinnamon (which still adds to
# 100), the total calorie count would be 40*8 + 60*3 = 500. The total score
# would go down, though: only 57600000, the best you can do in such trying
# circumstances.
#
# Given the ingredients in your kitchen and their properties, what is the total
# score of the highest-scoring cookie you can make with a calorie total of 500?
#
# Run:
#
#  Sprinkles: [2, 0, -2, 0]
#  Butterscotch: [0, 5, -3, 0]
#  Chocolate: [0, 0, 5, -1]
#  Candy: [0, -1, 0, 5]
#
#  STARTING INGREDIENTS Matrix[[2, 0, -2, 0], [0, 5, -3, 0], [0, 0, 5, -1], [0, -1, 0, 5]]
#  STARTING CALORIES    Matrix[[3], [3], [8], [8]]
#  BEST RECIPE: 1766400 Vector[46, 14, 30, 10]
#

require 'matrix'

TEST = false

if TEST
  ## TEST INPUT
  in_file = %{Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
  Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
  }.lines
else
  in_file = open('input.txt').readlines
end

def parse(line)
  ingred = nil
  props = {}

  if /([A-Z][a-z]+):/ =~ line
    # store ingredient name
    ingred = $1

    # get fields
    line.scan(/ ([a-z]+) (-?\d+)/).each do |property_match|
      props[property_match[0]] = property_match[1].to_i
    end
  end

  return ingred, props
end

def solve(vals, value)
  vals.inject(0) {|memo, v| memo + (v * value)}
end

def values(props)
  [
    props['capacity'],
    props['durability'],
    props['flavor'],
    props['texture'],
  ]
end

ingredients = []

in_file.each do |line|
  name, properties = parse(line)
  if name && properties
    ingredients << [name, {properties: properties, values: values(properties)}]
    puts "#{ name }: #{ values(properties) }"
  end
end

def solve_for(values, ingredient_matrix)
  (values * ingredient_matrix).inject(1) {|mult, ingred|
    if ingred < 0
      0
    else
      mult * ingred
    end
  }
end

tries = []
ingredient_matrix = Matrix[ *ingredients.map {|i| i[1][:values] } ]
calorie_matrix = Matrix[ *ingredients.map {|i| [i[1][:properties]['calories']] } ]

puts "STARTING INGREDIENTS #{ ingredient_matrix }"
puts "STARTING CALORIES    #{ calorie_matrix }"

if TEST
  ## TEST INPUT
  (0..100).each do |a|
    (0..(100 - a)).each do |b|
      next unless a + b == 100
      values = Matrix[ [a, b] ]

      # ROUND TWO
      next unless (values * calorie_matrix)[0, 0] == 500

      tries << [
        solve_for(values, ingredient_matrix),
        values
      ]
    end
  end
else
  ## First Round
  (0..100).each do |a|
    (0..(100 - a)).each do |b|
      (0..(100 - (a + b))).each do |c|
        (0..(100 - (a + b + c))).each do |d|
          next unless a + b + c + d == 100
          values = Matrix[ [a, b, c, d] ]

          # ROUND TWO
          next unless (values * calorie_matrix)[0, 0] == 500

          tries << [
            solve_for(values, ingredient_matrix),
            values.row(0)
          ]
        end
      end
    end
  end
end

best = tries.sort_by {|t| t[0]}.last
puts "BEST RECIPE: #{ best[0] } #{ best[1]}"


