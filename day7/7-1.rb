input = <<~INPUT.split("\n")
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
INPUT
input = File.read("input").split("\n")

RANKS = "23456789TJQKA"
BASE = RANKS.size + 1

def card_weight(card)
  RANKS.index(card) + 1
end

def sorted(hand)
  hand.chars.sort_by { card_weight(_1) }.reverse.join
end

# 00000-ccccc - high card values
# 1_00000 (BASE**5) - one pair
# 10_00000 (BASE**6)- two pairs
# 100_00000 (BASE**7) - three_of_kind
# 1000_00000 (BASE**8) - full house
# 10000_00000 (BASE**9) - four_of_kind
# 100000_00000 (BASE**10) - five_of_kind
def hand_weight(hand)
  weight = 0

  five_of_kind = ->(hand) { hand.chars.tally.values.include?(5) }
  four_of_kind = ->(hand) { hand.chars.tally.values.include?(4) }
  full_house = ->(hand) { hand.chars.tally.values.sort == [2, 3] }
  three_of_kind = ->(hand) { hand.chars.tally.values.include?(3) }
  two_pairs = ->(hand) { hand.chars.tally.values.count { _1 == 2 } == 2 }
  one_pair = ->(hand) { hand.chars.tally.values.count { _1 == 2 } == 1 }

  if five_of_kind.call(hand)
    weight += BASE**10
  elsif four_of_kind.call(hand)
    weight += BASE**9
  elsif full_house.call(hand)
    weight += BASE**8
  elsif three_of_kind.call(hand)
    weight += BASE**7
  elsif two_pairs.call(hand)
    weight += BASE**6
  elsif one_pair.call(hand)
    weight += BASE**5
  end

  weight += high_cards_weight(hand)

  weight
end

# convert sorted hand to 5 digit base 14 number
def high_cards_weight(hand)
  hand.chars.map { card_weight(_1).to_s(BASE) }.join.to_i(BASE)
end

# sort each hand by it's weight
sorted = input.sort_by do |hand_and_bet|
  hand, _ = hand_and_bet.split(" ")

  hand_weight(hand)
end

total_winnings = sorted.each_with_index.reduce(0) do |result, (hand_and_bet, index)|
  hand, bet = hand_and_bet.split(" ")
  result += bet.to_i * (index + 1)

  puts "#{hand} #{hand_weight(hand).to_s(BASE).rjust(12, "0")} - #{bet} * #{index + 1}"
  result
end

puts total_winnings
