require "progressbar"

input = <<~INPUT
  seeds: 79 14 55 13
  
  seed-to-soil map:
  50 98 2
  52 50 48
  
  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15
  
  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4
  
  water-to-light map:
  88 18 7
  18 25 70
  
  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13
  
  temperature-to-humidity map:
  0 69 1
  1 0 69
  
  humidity-to-location map:
  60 56 37
  56 93 4
INPUT
input = File.read("input")

categories = input.split("\n\n")
seed_ranges = categories.shift.split(":")[1].scan(/\d+ \d+/)

category_maps = {}
class Almanac < Hash
  def [](source)
    index = keys.index { |k| k.first <= source && source < k.last }
    return source if index.nil?

    range, dest_start = to_a[index]
    dest_start + (source - range.first)
  end
end

categories.each do |cat|
  cat_input = cat.split("\n")

  conversion = cat_input.shift[/(.*) map:/, 1]
  cat_almanac = Almanac.new

  cat_input.each do |line|
    dest_start, source_start, len = line.split(" ").map(&:to_i)
    cat_almanac[(source_start...(source_start + len))] = dest_start
  end

  category_maps[conversion] = cat_almanac
end

total_seeds = seed_ranges.map do |seed_range|
  _, length = seed_range.split(" ").map(&:to_i)
  length
end.sum

progressbar = ProgressBar.create(
  total: total_seeds,
  projector: {
    type: "smoothed",
    strength: 0.1
  },
  format: "%t |%B| %c/%C %a %e %p%%"
)

min = Float::INFINITY
seed_ranges.each do |seed_range|
  start, length = seed_range.split(" ").map(&:to_i)
  (start...start + length).each do |seed|
    progressbar.increment
    location = ["seed-to-soil", "soil-to-fertilizer", "fertilizer-to-water", "water-to-light", "light-to-temperature", "temperature-to-humidity", "humidity-to-location"].inject(seed) do |value, conversion|
      category_maps[conversion][value]
    end
    min = location if location < min
  end
end

puts min
