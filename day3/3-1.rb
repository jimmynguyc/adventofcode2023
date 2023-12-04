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

part_nos_and_coords = input.flat_map.with_index do |line, y|
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

def adjecent_to_symbol?(coord)
  surrounding_coords(coord).any? { |x, y| $matrix.dig(y, x).to_s.match?(/[^\d\.]/) } # not a digit or .
end

def part_number?(coords)
  coords.any? { adjecent_to_symbol?(_1) }
end

valid_part_nos = []
part_nos_and_coords.each do |no_and_coords|
  no, coords = no_and_coords
  valid_part_nos << no.to_i if part_number?(coords)
end

pp part_nos_and_coords.sort
puts valid_part_nos.sum
