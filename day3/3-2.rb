input = <<~INPUT.split("\n")
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
INPUT
input = File.read("input").split("\n")

$matrix = input.map(&:chars)

$part_nos_and_coords = input.flat_map.with_index do |line, y|
  part_number = ""
  memo = []
  results = []

  line.chars.each_with_index do |n, x|
    if n.match?(/\d/)
      part_number << n
      memo << [x, y]
    else
      results << [part_number, memo] unless part_number.empty?

      part_number = ""
      memo = []
    end
  end
  results << [part_number, memo] unless part_number.empty?

  results
end

gear_coords = input.flat_map.with_index do |line, y|
  results = []

  line.chars.each_with_index do |n, x|
    results << [x, y] if n == "*"
  end

  results
end

def surrounding_coords(coord)
  x, y = coord

  [
    [x, y - 1],     # top
    [x + 1, y],     # right
    [x, y + 1],     # bottom
    [x - 1, y],     # left
    [x - 1, y - 1], # top left
    [x + 1, y - 1], # top right
    [x + 1, y + 1], # bottom right
    [x - 1, y + 1]  # bottom left
  ].reject { _1.any?(&:negative?) } # reject out of bounds
end

def adjecent_parts(coord)
  surrounding_coords(coord).flat_map do |surrounding_coords|
    $part_nos_and_coords.select do |no, part_coords|
      part_coords.any? { _1 == surrounding_coords }
    end
  end.uniq.reject(&:empty?)
end

sum_of_gear_ratios = gear_coords.sum do |coord|
  adjecent_parts = adjecent_parts(coord)

  puts "Gear coords: #{coord} - #{adjecent_parts}"

  (adjecent_parts.count == 2) ? adjecent_parts.map { _1.first.to_i }.reduce(:*) : 0
end

puts sum_of_gear_ratios
