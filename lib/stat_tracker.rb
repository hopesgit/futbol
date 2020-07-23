require_relative './game_collection'
require_relative './team_collection'
require_relative './game_team_collection'

class StatTracker
  attr_reader :games,
              :teams,
              :game_teams

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
    game_team_collection.add_season_id(game_collection.all_games)
    @games = game_collection.all_games
    @teams = team_collection.all_teams
    @game_teams = game_team_collection.all_game_teams
  end


# ==================          Helper Methods       ==================

  def seasons
    @games.map {|game| game.season}.uniq
  end


  def total_goals_per_game
    @games.reduce({}) do |ids_to_scores, game|
      ids_to_scores[game.game_id] = game.away_goals + game.home_goals
      ids_to_scores
    end
  end

  def total_away_wins
    away_wins = 0
    @games.each do |game|
      if game.away_goals > game.home_goals
        away_wins += 1
      end
    end
    away_wins
  end

  def total_games
    @games.size
  end

  def total_home_wins
   @game_teams.find_all do |game_team|
     game_team.hoa == "home" && game_team.result == "WIN"
   end.size
  end

  def total_tied_games
   (@game_teams.find_all do |game_team|
      game_team.result == "TIE"
   end.size) / 2
  end

# ==================       Game Stats Methods      ==================

  def total_goals_per_season
    @games.reduce(Hash.new(0)) do |result, game|
      result[game.season] += game.away_goals + game.home_goals
      result
    end
  end

  def highest_total_score
    total_goals_per_game.max_by {|game_id, total_goals| total_goals}[1]
  end


  def lowest_total_score
    total_goals_per_game.min_by {|game_id, total_goals| total_goals}[1]
  end

  def percentage_visitor_wins
    ((total_away_wins / total_games.to_f) * 100).round(2)
  end

  def percentage_home_wins
    ((total_home_wins / total_games.to_f) * 100).round(2)
  end

  def percentage_ties
    ((total_tied_games / total_games.to_f) * 100).round(2)

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

  def average_goals_by_season
    seasons.reduce({}) do |result, season|
      result[season] = (total_goals_per_season[season] / count_of_games_by_season[season].to_f).round(2)
      result
    end
  end

# ==================       League Stats Methods      ==================

  def count_of_teams
    @teams.size
  end
end