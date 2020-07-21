require_relative './game'
require_relative './game_collection'

class StatTracker
  attr_reader :game_path,
              :team_path,
              :game_teams_path

  def self.from_csv(data)
    game_path = data[:games]
    team_path = data[:teams]
    game_teams_path = data[:game_teams]
    StatTracker.new(game_path, team_path, game_teams_path)
  end

  def initialize(game_path, team_path, game_teams_path)
    @game_path = game_path
    @team_path = team_path
    @game_teams_path = game_teams_path
    # @team_collection = TeamCollection.new(team_path)
    @game_collection = GameCollection.new(game_path)
    @games = @game_collection.all_games
  end

# Game Statistics Tests - Helper Methods #
  def total_goals 
    @games.reduce(0) do |total, game|
      total += game.away_goals + game.home_goals
      total
    end
  end 

  def total_goals_per_game
    @games.reduce({}) do |ids_to_scores, game|
      ids_to_scores[game.game_id] = game.away_goals + game.home_goals
      ids_to_scores
    end
  end

  # def total_goals_per_game_per_season 
  #   @games.reduce(Hash.new { |h, k| h[k] = [] }) do |seasons_to_scores, game|
  #     seasons_to_scores[game.season] << game.away_goals + game.home_goals
  #     require 'pry'; binding.pry
  #     seasons_to_scores
  #   end 
  # end

  def list_total_goals_per_game_or_season(game_or_season)
    @games.reduce(Hash.new { |h, k| h[k] = [] }) do |result, game|
      result[game.send(game_or_season)] << game.away_goals + game.home_goals
      result
    end 
  end

  def total_goals_per_game_or_season(game_or_season) 
    list_total_goals_per_game_or_season(game_or_season).each do |goal|
      goal[1].sum  
    end
  end

# Game Statistics Tests - Stat Methods #
  def highest_total_score
    total_goals_per_game.max_by {|game_id, total_goals| total_goals}[1]
  end
end