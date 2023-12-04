input = <<~INPUT
  two1nine
  eightwothree
  abcone2threexyz
  xtwone3four
  4nineeightseven2
  zoneight234
  7pqrstsixteen
INPUT
input = File.read("input").split("\n")

str_to_number = {
  one: "1",
  two: "2",
  three: "3",
  four: "4",
  five: "5",
  six: "6",
  seven: "7",
  eight: "8",
  nine: "9",
  zero: "0"
}

calibration_value = input.sum do |str|
  matches = str.scan(/(?=(one|two|three|four|five|six|seven|eight|nine|0|1|2|3|4|5|6|7|8|9))/).flatten
  scans = matches.map { |n| str_to_number[n.to_sym] || n }

  scans.values_at(0, -1).join.to_i
end

puts calibration_value
