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

def empty_row?(y)
  (0...IMAGE[y].size).all? { |x| IMAGE[y][x] == "." }
end

def empty_col?(x)
  (0...IMAGE.size).all? { |y| IMAGE[y][x] == "." }
end

# Expand Galaxy
empty_rows = (0...IMAGE.size).select { |y| empty_row?(y) }
empty_cols = (0...IMAGE[0].size).select { |x| empty_col?(x) }

empty_rows.reverse.each do |y|
  IMAGE.insert(y, ["."] * IMAGE[0].size)
end

empty_cols.reverse.each do |x|
  (0...IMAGE.size).each do |y|
    IMAGE[y].insert(x, ".")
  end
end

galaxy_locations = []

(0...IMAGE.size).each do |y|
  (0...IMAGE[y].size).each do |x|
    galaxy_locations << [x, y] if IMAGE[y][x] == "#"
  end
end

galaxy_groups = galaxy_locations.permutation(2).map(&:sort).uniq

def distance(gal1, gal2)
  (gal1[0] - gal2[0]).abs + (gal1[1] - gal2[1]).abs
end

sum_of_shortest_path = galaxy_groups.sum { |group| distance(*group) }

puts sum_of_shortest_path
