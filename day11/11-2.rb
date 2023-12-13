INPUT = <<~INPUT.split("\n")
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
INPUT
INPUT = File.read("input").split("\n")

IMAGE = INPUT.map(&:chars)
EXPANSION_SIZE = 1_000_000

def empty_row?(y)
  (0...IMAGE[y].size).all? { |x| IMAGE[y][x] == "." }
end

def empty_col?(x)
  (0...IMAGE.size).all? { |y| IMAGE[y][x] == "." }
end

# Expand Galaxy
EMPTY_ROWS = (0...IMAGE.size).select { |y| empty_row?(y) }
EMPTY_COLS = (0...IMAGE[0].size).select { |x| empty_col?(x) }

galaxy_locations = []
(0...IMAGE.size).each do |y|
  (0...IMAGE[y].size).each do |x|
    galaxy_locations << [x, y] if IMAGE[y][x] == "#"
  end
end

galaxy_groups = galaxy_locations.permutation(2).map(&:sort).uniq

def distance(gal1, gal2)
  horizontal_dist = (gal1[0] - gal2[0]).abs
  horizontal_empty_spaces = EMPTY_COLS.select do |x|
    left, right = [gal1[0], gal2[0]].sort
    x.between?(left + 1, right)
  end
  horizontal_dist += horizontal_empty_spaces.size * EXPANSION_SIZE - horizontal_empty_spaces.size

  vertical_dist = (gal1[1] - gal2[1]).abs
  vertical_empty_spaces = EMPTY_ROWS.select do |y|
    top, bottom = [gal1[1], gal2[1]].sort
    y.between?(top + 1, bottom)
  end
  vertical_dist += vertical_empty_spaces.size * EXPANSION_SIZE - vertical_empty_spaces.size

  horizontal_dist + vertical_dist
end

sum_of_shortest_path = galaxy_groups.sum { |x, y| distance(x, y) }

puts sum_of_shortest_path
