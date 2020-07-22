require_relative './game'
require_relative './game_collection'
require_relative './team_collection'
require_relative './game_team_collection'

class StatTracker
  attr_reader :game_collection,
              :team_collection,
              :teams

  def self.from_csv(locations)
    game_path = locations[:games]
    team_path = locations[:teams]
    game_teams_path = locations[:game_teams]

    self.new(game_path, team_path, game_teams_path)
  end

  def initialize(game_path, team_path, game_teams_path)
    game_collection = GameCollection.new(game_path)
    team_collection = TeamCollection.new(team_path)
    game_team_collection = GameTeamCollection.new(game_teams_path)
    @games = game_collection.all_games
    @teams = team_collection.all_teams
    @game_teams = game_team_collection.all_game_teams
  end


  # Game Statistics #
  # Helper Methods #
  def total_goals_per_game
    @games.reduce({}) do |ids_to_scores, game|
      ids_to_scores[game.game_id] = game.away_goals + game.home_goals
      ids_to_scores
    end
  end

  def total_games_per_team(exclude_hoa = nil)
    @game_teams.reduce(Hash.new(0)) do |result, game_team|
      result[game_team.team_id] += 1 unless game_team.hoa == exclude_hoa
      result
    end
  end

# Game Statistics Tests - Stat Methods #
  def highest_total_score
    total_goals_per_game.max_by {|game_id, total_goals| total_goals}[1]
  end

  def count_of_games_by_season
    season_games = Hash.new(0)
    @games.each do |game|
      season_games[game.season] += 1
    end
    season_games
  end

  def average_goals_per_game
    result = total_goals_per_game.values.sum
    (result / total_goals_per_game.keys.count.to_f).round(2)
  end

# ==================       League Stats Methods      ==================

end
