require_relative './game'
require 'csv'

class GameCollection
  attr_reader :game_collection

  def initialize(game_path)
    @game_collection = create_games(game_path)
  end

  def create_games(game_path)
    csv = CSV.read(game_path, headers: true, header_converters: :symbol)
    csv.map do |row|
      Game.new(row)
    end
  end

  def average_goals_per_game
    total_goals = 0
    @game_collection.each do |game|
      total_goals += game.away_goals
      total_goals += game.home_goals
    end
    (total_goals / @game_collection.count.to_f).round(2)
  end

  def count_of_games_by_season
    season_games = Hash.new(0)
    @game_collection.each do |game|
      season_games[game.season] += 1
    end
    season_games
  end

end
