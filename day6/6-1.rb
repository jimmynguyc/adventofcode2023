# Time:      7  15   30
# Distance:  9  40  200
#
# race_params = [
#   {total_time: 7, distance: 9},
#   {total_time: 15, distance: 40},
#   {total_time: 30, distance: 200}
# ]

# Time:        40     82     91     66
# Distance:   277   1338   1349   1063
race_params = [
  {total_time: 40, distance: 277},
  {total_time: 82, distance: 1338},
  {total_time: 91, distance: 1349},
  {total_time: 66, distance: 1063}
]

# Formula
# =======
# Given Winning Distance WD, Total Time TT.
# Find range of Pressed Time PT, where PT ∈ Z (is an integer), and PT < TT.
#
# Speed S = PT
# Remaining Time = RT
# Distance travelled D = S * RT = S * (TT - PT) = PT * (TT * PT)
#
# Since D > WD,
# => PT * (TT * PT) > WD
#
# Therefore, solve PT
# (1) PT > 1/2 * (TT - sqrt(TT**2 - 4*WD))
# (2) PT < 1/2 * (sqrt(TT**2 - 4*WD) + TT)
#
def winning_strategies(race)
  total_time = race[:total_time]
  winning_distance = race[:distance]

  range_start = (0.5 * (total_time - Math.sqrt(total_time**2 - (4 * winning_distance)))).ceil
  range_start += 1 if range_start % 1 == 0 # range start is a round number

  range_end = (0.5 * (Math.sqrt(total_time**2 - (4 * winning_distance)) + total_time)).ceil

  range_end = [range_end, total_time].min

  puts "time: #{total_time}, range: #{range_start}...#{range_end}"
  (range_start..range_end).count
end

result = race_params.inject(1) do |product, race|
  count = winning_strategies(race)
  product * count
end

puts result
