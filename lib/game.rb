require 'csv'
require_relative './helpable'

class Game
  extend Helpable

  attr_reader :game_id,
              :season,
              :type,
              :date_time,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals
  @@all_games = []

  def initialize(info)
    @game_id = info[:game_id]
    @season = info[:season]
    @type = info[:type]
    @date_time = info[:date_time]
    @away_team_id = info[:away_team_id]
    @home_team_id = info[:home_team_id]
    @away_goals = info[:away_goals].to_i
    @home_goals = info[:home_goals].to_i
  end

  def self.create(game_path)
    CSV.foreach(game_path, headers: true, header_converters: :symbol) do |row|
      @@all_games << Game.new(row.to_h)
    end
  end

  def self.games 
    @@all_games
  end 

  def self.count
    @@all_games.count
  end

  def self.total_away_wins
    @@all_games.reduce(0) do |away_wins, game|
      away_wins += 1 if game.away_goals > game.home_goals
      away_wins
    end
  end

  def self.total_goals_per_season
    @@all_games.reduce(Hash.new(0)) do |result, game|
      result[game.season] += game.away_goals + game.home_goals
      result
    end
  end

  def self.count_of_games_by_season
    season_games = Hash.new(0)
    @@all_games.each do |game|
      season_games[game.season] += 1
    end
    season_games
  end

  def self.total_tied_games
    @@all_games.reduce(0) do |ties, game|
      ties += 1 if game.away_goals == game.home_goals
      ties
    end
  end

  def self.total_goals_per_game
    @@all_games.reduce({}) do |ids_to_scores, game|
      ids_to_scores[game.game_id] = game.away_goals + game.home_goals
      ids_to_scores
    end
  end

  def self.highest_total_score
    Game.total_goals_per_game.max_by {|game_id, total_goals| total_goals}[1]
  end

  def self.lowest_total_score
    Game.total_goals_per_game.min_by {|game_id, total_goals| total_goals}[1]
  end

  def self.all_seasons
    @@all_games.map { |game| game.season }.uniq
  end
end
