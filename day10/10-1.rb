INPUT = <<~INPUT.split("\n")
  7-F7-
  .FJ|7
  SJLL7
  |F--J
  LJ.LJ
INPUT
INPUT = File.read("input").split("\n")

MATRIX = INPUT.map(&:chars)

# The pipes are arranged in a two-dimensional grid of tiles:
#    | is a vertical pipe connecting north and south.
#    - is a horizontal pipe connecting east and west.
#    L is a 90-degree bend connecting north and east.
#    J is a 90-degree bend connecting north and west.
#    7 is a 90-degree bend connecting south and west.
#    F is a 90-degree bend connecting south and east.
#    . is ground; there is no pipe in this tile.
#    S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
#
PIPES = {
  "|" => ["N", "S"],
  "-" => ["E", "W"],
  "L" => ["N", "E"],
  "J" => ["N", "W"],
  "7" => ["S", "W"],
  "F" => ["S", "E"]
}

def start_pos
  (0...INPUT.size).each do |row|
    col = INPUT[row].index("S")
    return [col, row] unless col.nil?
  end
end

def pipes_connected_on_the(dir)
  PIPES.select { |_, v| v.include?(dir) }.keys
end

def connections(pos)
  x, y = pos
  i_am = MATRIX[y][x]
  connections = []

  case i_am
  when "|"
    connections << [x, y + 1] if pipes_connected_on_the("N").include?(MATRIX[y + 1][x])
    connections << [x, y - 1] if pipes_connected_on_the("S").include?(MATRIX[y - 1][x])
  when "-"
    connections << [x + 1, y] if pipes_connected_on_the("W").include?(MATRIX[y][x + 1])
    connections << [x - 1, y] if pipes_connected_on_the("E").include?(MATRIX[y][x - 1])
  when "L"
    connections << [x + 1, y] if pipes_connected_on_the("W").include?(MATRIX[y][x + 1])
    connections << [x, y - 1] if pipes_connected_on_the("S").include?(MATRIX[y - 1][x])
  when "J"
    connections << [x - 1, y] if pipes_connected_on_the("E").include?(MATRIX[y][x - 1])
    connections << [x, y - 1] if pipes_connected_on_the("S").include?(MATRIX[y - 1][x])
  when "7"
    connections << [x - 1, y] if pipes_connected_on_the("E").include?(MATRIX[y][x - 1])
    connections << [x, y + 1] if pipes_connected_on_the("N").include?(MATRIX[y + 1][x])
  when "F"
    connections << [x + 1, y] if pipes_connected_on_the("W").include?(MATRIX[y][x + 1])
    connections << [x, y + 1] if pipes_connected_on_the("N").include?(MATRIX[y + 1][x])
  else
    connections << [x + 1, y] if pipes_connected_on_the("W").include?(MATRIX[y][x + 1])
    connections << [x - 1, y] if pipes_connected_on_the("E").include?(MATRIX[y][x - 1])
    connections << [x, y + 1] if pipes_connected_on_the("N").include?(MATRIX[y + 1][x])
    connections << [x, y - 1] if pipes_connected_on_the("S").include?(MATRIX[y - 1][x])
  end

  connections
end

explored = []
distance = 0

current_pos = start_pos
puts current_pos.inspect
loop do
  distance += 1
  x, y = (connections(current_pos) - explored)[0]

  break if x.nil?

  explored << [x, y]
  current_pos = [x, y]
  puts current_pos.inspect
end

# (0...MATRIX.size).each do |y|
#   (0...MATRIX[0].size).each do |x|
#     char = if start_pos == [x, y]
#       "S  "
#     elsif explored.include?([x, y])
#       (explored.index([x, y]) + 1).to_s.ljust(3)
#       # MATRIX[y][x].ljust(3)
#     else
#       ".  "
#     end
#     printf("%s", char)
#   end
#   puts ""
# end

puts distance.fdiv(2).ceil
