input = <<~INPUT.split("\n")
  LR
  
  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)
INPUT
input = File.read("input").split("\n")

instructions = input.shift.chars
maps = input.reject(&:empty?).each_with_object({}) do |map, obj|
  source, dest = map.split(" = ")
  obj[source] = dest.scan(/\((.{3}), (.{3})\)/).flatten
end

locations = maps.keys.select { _1.end_with?("A") }
locations_steps = locations.map do |location|
  steps = 0
  until location.end_with?("Z")
    current_ins = instructions[steps % instructions.length]

    location = if current_ins == "L"
      maps[location][0]
    else
      maps[location][1]
    end

    steps += 1
  end
  steps
end

# least common multiple
puts locations_steps.reduce(1) { |acc, n| acc.lcm(n) }
