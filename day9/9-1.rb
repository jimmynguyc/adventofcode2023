input = <<~INPUT.split("\n")
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
INPUT
input = File.read("input").split("\n")
def groups_of_2(array)
  array.each_cons(2).map(&:join)
end

all_series = input.map do |row|
  series = row.split(" ").map(&:to_i)
  breakdown = [series]

  until breakdown.last.all?(&:zero?)
    series = series.each_cons(2).map { |a, b| b - a }
    breakdown << series
  end

  breakdown.pop # don't care about zeroes

  series << breakdown.reverse_each.reduce(0) { |memo, series| series.last + memo }
end

answer = all_series.sum { _1.last }
puts answer
