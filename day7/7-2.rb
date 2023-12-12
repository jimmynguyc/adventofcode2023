input = <<~INPUT.split("\n")
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
INPUT
input = File.read("input").split("\n")

RANKS = "J23456789TQKA"
HAND_RANKS = [
  :five_of_kind,
  :four_of_kind,
  :full_house,
  :three_of_kind,
  :two_pairs,
  :one_pair,
  :high_card
].reverse
BASE = RANKS.size + 1

def card_weight(card)
  RANKS.index(card) + 1
end

def sorted(hand)
  hand.chars.sort_by { card_weight(_1) }.reverse.join
end

def best_possible_hand(hand)
  possible_hands = [type_of_hand(hand)]

  normal_cards = hand.chars.reject { _1 == "J" }

  normal_cards.each do |c|
    puts "Possible hand: #{hand} -> #{hand.gsub("J", c)}"
    possible_hands << type_of_hand(hand.gsub("J", c))
  end

  possible_hands.max_by { HAND_RANKS.index(_1) }
end

def type_of_hand(hand)
  five_of_kind = ->(hand) { hand.chars.tally.values.include?(5) }
  four_of_kind = ->(hand) { hand.chars.tally.values.include?(4) }
  full_house = ->(hand) { hand.chars.tally.values.sort == [2, 3] }
  three_of_kind = ->(hand) { hand.chars.tally.values.include?(3) }
  two_pairs = ->(hand) { hand.chars.tally.values.count { _1 == 2 } == 2 }
  one_pair = ->(hand) { hand.chars.tally.values.count { _1 == 2 } == 1 }

  return :five_of_kind if five_of_kind.call(hand)
  return :four_of_kind if four_of_kind.call(hand)
  return :full_house if full_house.call(hand)
  return :three_of_kind if three_of_kind.call(hand)
  return :two_pairs if two_pairs.call(hand)
  return :one_pair if one_pair.call(hand)

  :high_card
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

  hand_type = if hand.include?("J")
    best_possible_hand(hand)
  else
    type_of_hand(hand)
  end

  case hand_type
  when :five_of_kind
    weight += BASE**10
  when :four_of_kind
    weight += BASE**9
  when :full_house
    weight += BASE**8
  when :three_of_kind
    weight += BASE**7
  when :two_pairs
    weight += BASE**6
  when :one_pair
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
