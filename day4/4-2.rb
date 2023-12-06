$input = <<~INPUT.split("\n")
  Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
  Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
  Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
  Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
INPUT
$input = File.read("input").split("\n")

def parse_card(card)
  _, numbers = card.split(":")

  winning_numbers, numbers_we_have = numbers.split("|")
  winning_numbers = winning_numbers.split(" ").map(&:to_i)
  numbers_we_have = numbers_we_have.split(" ").map(&:to_i)

  matches = numbers_we_have.count { winning_numbers.include?(_1) }

  {winning_numbers:, numbers_we_have:, matches:}
end

$total_cards = $input.count

def process_card(card, index)
  parsed = parse_card(card)
  parsed[:matches].times do |count|
    next_index = index + count + 1
    next if next_index >= $input.count
    process_card($input[next_index], next_index)
  end
  $total_cards += parsed[:matches]
end

$input.each.with_index { process_card(_1, _2) }

puts $total_cards
