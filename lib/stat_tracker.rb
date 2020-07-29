require_relative './game'
require_relative './team'
require_relative './game_team'
require_relative './helpable'

class StatTracker
  include Helpable

  def self.from_csv(locations)
    game_path = locations[:games]
    team_path = locations[:teams]
    game_teams_path = locations[:game_teams]
    self.new(game_path, team_path, game_teams_path)
  end

  def initialize(game_path, team_path, game_teams_path)
    Game.create(game_path)
    Team.create(team_path)
    GameTeam.create(game_teams_path)
  end

# ==================       Game Stats Methods      ==================

  def highest_total_score
    Game.highest_total_score
  end

  def lowest_total_score
    Game.lowest_total_score
  end

  def percentage_home_wins
    (GameTeam.total_home_wins / Game.count.to_f).round(2)
  end

  def percentage_visitor_wins
    (Game.total_away_wins / Game.count.to_f).round(2)
  end

  def percentage_ties
    (Game.total_tied_games / Game.count.to_f).round(2)
  end

  def count_of_games_by_season
    Game.count_of_games_by_season
  end

  def average_goals_per_game
    Game.average_goals_per_game
  end

  def average_goals_by_season
    Game.average_goals_by_season
  end

# ==================       League Stats Methods      ==================

  def count_of_teams
    Team.count
  end

  def best_offense
    average_goals_per_game_per_team.max_by { |team, avg| avg }[0].name
  end

  def worst_offense
    average_goals_per_game_per_team.min_by { |team, avg| avg}[0].name
  end

  def highest_scoring_visitor
    exclude = "home"
    average_goals_per_game_per_team(exclude).max_by { |team, avg| avg }[0].name
  end

  def highest_scoring_home_team
    exclude = "away"
    average_goals_per_game_per_team(exclude).max_by { |team, avg| avg }[0].name
  end

  def lowest_scoring_visitor
    exclude = "home"
    average_goals_per_game_per_team(exclude).min_by { |team, avg| avg }[0].name
  end

  def lowest_scoring_home_team
    exclude = "away"
    average_goals_per_game_per_team(exclude).min_by { |team, avg| avg }[0].name
  end

# ==================       Season Stats Methods      ==================

  def winningest_coach(season_id)
    GameTeam.winningest_coach(season_id)
  end

  def worst_coach(season_id)
    GameTeam.worst_coach(season_id)
  end

  def most_accurate_team(season_id)
    best = GameTeam.shots_to_goals_ratio_per_team_for_season(season_id).min_by { |team_id, avg| avg}[0]
    find_team(best).name
  end

  def least_accurate_team(season_id)
    worst = GameTeam.shots_to_goals_ratio_per_team_for_season(season_id).max_by { |team_id, avg| avg}[0]
    find_team(worst).name
  end

  def most_tackles(season_id)
    tackles_per_team_for(season_id).max_by do |team_id, tackles|
      tackles
    end[0]
  end

  def fewest_tackles(season_id)
    tackles_per_team_for(season_id).min_by do |team_id, tackles|
      tackles
    end[0]
  end

# ==================       Team Stats Methods      ==================

  def team_info(team_id)
    team = find_team(team_id)
    { "team_id" => team.id, "franchise_id" => team.franchise_id, "team_name" => team.name, "abbreviation" => team.abbreviation, "link" => team.link
    }
  end

  def best_season(team_id)
    Team.best_season(team_id)
  end

  def worst_season(team_id)
    Team.worst_season(team_id)
  end

  def average_win_percentage(team_id)
    Team.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id)
    GameTeam.goals_per_game_per_team[team_id].max
  end

  def fewest_goals_scored(team_id)
    GameTeam.goals_per_game_per_team[team_id].min
  end

  def favorite_opponent(team_id)
    Team.favorite_opponent(team_id)
  end

  def rival(team_id)
    Team.rival(team_id)
  end
end
