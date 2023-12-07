# Time:      71530
# Distance:  940200
#
# race_params = [
#   {total_time: 71530, distance: 940200}
# ]

# Time:        40829166
# Distance:   277133813491063

race_params = [
  {total_time: 40829166, distance: 277133813491063}
]

# Formula
# =======
# Given Winning Distance WD, Total Time TT. Find range of Pressed Time PT, where
# - Distance Travelled D > WD
# - PT ∈ Z (is an integer)
# - PT < TT.
#
# Speed S = PT
# Remaining Time = RT
#
# D = S * RT
#   = S * (TT - PT)
#   = PT * (TT - PT)
#
# Since D > WD,
#   => PT * (TT - PT) > WD
#
# Solve for PT - https://www.wolframalpha.com/input?i=Solve+for+x%2C+where+x+*+%28y+-+x%29+%3E+z
#   => 1/2 * (TT - sqrt(TT**2 - 4*WD)) < PT < 1/2 * (sqrt(TT**2 - 4*WD) + TT)
#
# Find all integer PTs that satisfy
#   (1) PT > 1/2 * (TT - sqrt(TT**2 - 4*WD))
#   (2) PT < 1/2 * (sqrt(TT**2 - 4*WD) + TT)
#
def winning_strategies(race)
  total_time = race[:total_time]
  winning_distance = race[:distance]

  range_start = (0.5 * (total_time - Math.sqrt(total_time**2 - (4 * winning_distance)))).ceil
  range_start += 1 if range_start % 1 == 0 # range_start > PT, otherwise range_start == PT

  range_end = (0.5 * (Math.sqrt(total_time**2 - (4 * winning_distance)) + total_time)).ceil
  range_end = [range_end, total_time].min # PT < TT

  puts "time: #{total_time}, range: #{range_start}..#{range_end}"
  (range_start..range_end).count
end

result = race_params.inject(1) do |product, race|
  count = winning_strategies(race)
  product * count
end

puts result
