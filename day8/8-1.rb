input = <<~INPUT.split("\n")
  RL
  
  AAA = (BBB, CCC)
  BBB = (DDD, EEE)
  CCC = (ZZZ, GGG)
  DDD = (DDD, DDD)
  EEE = (EEE, EEE)
  GGG = (GGG, GGG)
  ZZZ = (ZZZ, ZZZ)
INPUT
input = <<~INPUT.split("\n")
  LLR
  
  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
INPUT
input = File.read('input').split("\n")

instructions = input.shift.chars
maps = input.reject(&:empty?).each_with_object({}) do |map, obj|
  source, dest = map.split(" = ")
  obj[source] = dest.scan(/\((.{3}), (.{3})\)/).flatten
end

location = "AAA"
steps = 0
while location != "ZZZ"
  current_ins = instructions[steps % instructions.length]

  location = if current_ins == "L"
    maps[location][0]
  else
    maps[location][1]
  end

  steps += 1
end

puts steps
