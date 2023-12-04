input = <<~INPUT
  1abc2
  pqr3stu8vwx
  a1b2c3d4e5f
  treb7uchet
INPUT
input = File.read("input").split("\n")

res = input.sum do |str|
  scans = str.scan(/\d/)
  "#{scans.first}#{scans.last}".to_i
end

puts res
