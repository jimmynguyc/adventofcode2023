input = <<~INPUT
  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
INPUT
input = File.read("input").split("\n")

def parse_game(game)
  rounds = game.split(";").map do |round|
    game = {
      red: round[/(\d+) red/, 1].to_i,
      blue: round[/(\d+) blue/, 1].to_i,
      green: round[/(\d+) green/, 1].to_i
    }

    game.merge(valid: valid_game?(game))
  end

  {
    rounds:,
    valid: rounds.all? { _1[:valid] }
  }
end

def valid_game?(game)
  bag_contains = {
    total: 12 + 13 + 14,
    red: 12,
    green: 13,
    blue: 14
  }

  return false if game.values.sum > bag_contains[:total]
  return false if game[:red] > bag_contains[:red]
  return false if game[:green] > bag_contains[:green]
  return false if game[:blue] > bag_contains[:blue]

  true
end

games = input.each_with_object({}) do |game_input, memo|
  title, game = game_input.split(":")
  id = title[/Game (\d+)$/, 1].to_i

  parsed_game = parse_game(game)

  memo[id] = {raw: game_input}
    .merge(parsed_game)
    .merge(
      minimums: {
        red: parsed_game[:rounds].max_by { _1[:red] }[:red],
        green: parsed_game[:rounds].max_by { _1[:green] }[:green],
        blue: parsed_game[:rounds].max_by { _1[:blue] }[:blue]
      }
    )
  memo
end

pp games

sum_of_ids = games.sum do |id, game|
  game[:valid] ? id : 0
end

puts sum_of_ids

sum_of_powers = games.values.sum do |game|
  game[:minimums].values.inject(&:*)
end

puts sum_of_powers
