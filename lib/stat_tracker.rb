require_relative './game'
require_relative './game_collection'
require 'csv'

class StatTracker
  attr_reader :game_collection,
              :team_collection,
              :games,
              :teams,
              :game_teams

  def initialize(game_path, team_path, game_team_path)
    @game_collection = GameCollection.new(game_path)
    @teams_collection = #TeamCollection.new(team_path, game_team_path)
    @games = @game_collection.all_games
    #@teams = @teams_collection.total_teams
    #@game_teams = @teams_collection.total_games
  end

  def self.from_csv(locations)
    game_path = locations[:games]
    team_path = locations[:teams]
    game_team_path = locations[:game_teams]

    self.new(game_path, team_path, game_team_path)
  end

  #Game Statistics
  def average_goals_per_game
    total_goals = 0
    @games.each do |game|
      total_goals += game.away_goals
      total_goals += game.home_goals
    end
    (total_goals / @games.count.to_f).round(2)
  end

  def count_of_games_by_season
    season_games = Hash.new(0)
    @games.each do |game|
      season_games[game.season] += 1
    end
    season_games
  end



end
