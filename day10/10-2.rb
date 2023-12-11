require "rmagick"
require "json"

INPUT = <<~INPUT.split("\n")
  ...........
  .S-------7.
  .|F-----7|.
  .||.....||.
  .||.....||.
  .|L-7.F-J|.
  .|..|.|..|.
  .L--J.L--J.
  ...........
INPUT
INPUT = <<~INPUT.split("\n")
  ..........
  .S------7.
  .|F----7|.
  .||OOOO||.
  .||OOOO||.
  .|L-7F-J|.
  .|..||..|.
  .L--JL--J.
  ..........
INPUT
INPUT = <<~INPUT.split("\n")
  .F----7F7F7F7F-7....
  .|F--7||||||||FJ....
  .||.FJ||||||||L7....
  FJL7L7LJLJ||LJ.L-7..
  L--J.L7...LJS7F-7L7.
  ....F-J..F7FJ|L7L7L7
  ....L7.F7||L7|.L7L7|
  .....|FJLJ|FJ|F7|.LJ
  ....FJL-7.||.||||...
  ....L---J.LJ.LJLJ...
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
  "|" => ["N", "S"].sort,
  "-" => ["E", "W"].sort,
  "L" => ["N", "E"].sort,
  "J" => ["N", "W"].sort,
  "7" => ["S", "W"].sort,
  "F" => ["S", "E"].sort
}

def start_pos
  @start_pos ||= (0...INPUT.size).each do |row|
    col = INPUT[row].index("S")
    return [col, row] unless col.nil?
  end
end

def pipes_connected_on_the(dir)
  PIPES.select { |_, v| v.include?(dir) }.keys << "S"
end

def connections(pos)
  x, y = pos
  return [] unless x

  i_am = MATRIX[y][x]
  connections = []

  case i_am
  when "|"
    connections << [x, y + 1] if pipes_connected_on_the("N").include?(MATRIX.dig(y + 1, x))
    connections << [x, y - 1] if pipes_connected_on_the("S").include?(MATRIX.dig(y - 1, x))
  when "-"
    connections << [x + 1, y] if pipes_connected_on_the("W").include?(MATRIX.dig(y, x + 1))
    connections << [x - 1, y] if pipes_connected_on_the("E").include?(MATRIX.dig(y, x - 1))
  when "L"
    connections << [x + 1, y] if pipes_connected_on_the("W").include?(MATRIX.dig(y, x + 1))
    connections << [x, y - 1] if pipes_connected_on_the("S").include?(MATRIX.dig(y - 1, x))
  when "J"
    connections << [x - 1, y] if pipes_connected_on_the("E").include?(MATRIX.dig(y, x - 1))
    connections << [x, y - 1] if pipes_connected_on_the("S").include?(MATRIX.dig(y - 1, x))
  when "7"
    connections << [x - 1, y] if pipes_connected_on_the("E").include?(MATRIX.dig(y, x - 1))
    connections << [x, y + 1] if pipes_connected_on_the("N").include?(MATRIX.dig(y + 1, x))
  when "F"
    connections << [x + 1, y] if pipes_connected_on_the("W").include?(MATRIX.dig(y, x + 1))
    connections << [x, y + 1] if pipes_connected_on_the("N").include?(MATRIX.dig(y + 1, x))
  else
    connections << [x + 1, y] if pipes_connected_on_the("W").include?(MATRIX.dig(y, x + 1))
    connections << [x - 1, y] if pipes_connected_on_the("E").include?(MATRIX.dig(y, x - 1))
    connections << [x, y + 1] if pipes_connected_on_the("N").include?(MATRIX.dig(y + 1, x))
    connections << [x, y - 1] if pipes_connected_on_the("S").include?(MATRIX.dig(y - 1, x))
  end

  connections
end

LOOP_COORDS = if File.exist?("loop_coords")
  JSON.parse(File.read("loop_coords"))
else
  loop_coords = [start_pos]
  current_pos = start_pos
  loop do
    x, y = (connections(current_pos) - loop_coords)[0]

    break if x.nil?

    loop_coords << [x, y]
    current_pos = [x, y]
  end

  File.write("loop_coords", loop_coords.to_json)
  loop_coords
end

img = Magick::ImageList.new
img.new_image(MATRIX[0].size, MATRIX.size, Magick::HatchFill.new("black", "black"))

gc = Magick::Draw.new
gc.stroke("blue").stroke_width(1)
gc.fill("red")
gc.polygon(*LOOP_COORDS.flatten)
gc.draw(img)

tiles_enclosed = 0
(0...MATRIX.size).each do |y|
  (0...MATRIX[0].size).each do |x|
    tiles_enclosed += 1 if img.pixel_color(x, y).red > 0
  end
end
puts tiles_enclosed
