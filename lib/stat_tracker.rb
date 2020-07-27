require_relative './game'
require_relative './team_collection'
require_relative './game_team_collection'
require_relative './helpable'

class StatTracker
  include Helpable

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
    game_team_collection = GameTeamCollection.new(game_teams_path)
    Game.create(game_path)
    @games = Game.class_variable_get(:@@all_games)
    Team.create(team_path)
    @teams = Team.class_variable_get(:@@all_teams)
    @game_teams = game_team_collection.all_game_teams
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
    (total_away_wins / total_games.to_f).round(2)
  end

  def percentage_home_wins
    (total_home_wins / total_games.to_f).round(2)
  end

  def percentage_ties
    (total_tied_games / total_games.to_f).round(2)
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
    all_seasons.reduce({}) do |result, season|
      result[season] = (total_goals_per_season[season] / count_of_games_by_season[season].to_f).round(2)
      result
    end
  end

# ==================       League Stats Methods      ==================

  def best_offense
    average_goals_per_game_per_team.max_by { |team, avg| avg }[0].name
  end

  def highest_scoring_visitor
    exclude = "home"
    average_goals_per_game_per_team(exclude).max_by { |team, avg| avg }[0].name
  end

  def lowest_scoring_visitor
    exclude = "home"
    average_goals_per_game_per_team(exclude).min_by { |team, avg| avg }[0].name
  end

  def highest_scoring_home_team
    exclude = "away"
    average_goals_per_game_per_team(exclude).max_by { |team, avg| avg }[0].name
  end

  def count_of_teams
    @teams.size
  end

  def worst_offense
    average_goals_per_game_per_team.min_by { |team, avg| avg}[0].name
  end

  def lowest_scoring_home_team
    exclude = "away"
    average_goals_per_game_per_team(exclude).min_by { |team, avg| avg }[0].name
  end

# ==================       Season Stats Methods      ==================

  def fewest_tackles(season_id)
    tackles_per_team_for(season_id).min_by do |team_id, tackles|
      tackles
    end[0]
  end

  def least_accurate_team(season_id)
    worst = shots_to_goals_ratio_per_team_per_season(season_id).max_by { |team_id, avg| avg}[0]
    find_team(worst).name
  end

  def most_accurate_team(season_id)
    best = shots_to_goals_ratio_per_team_per_season(season_id).min_by { |team_id, avg| avg}[0]
    find_team(best).name
  end

  def winningest_coach(season_id)
    percent_wins_by_coach(season_id).max_by do |coach, percent_wins|
      percent_wins
    end[0]
  end

  def most_tackles(season_id)
    tackles_per_team_for(season_id).max_by do |team_id, tackles|
      tackles
    end[0]
  end

# ==================       Team Stats Methods      ==================

  def team_info(team_id)
    team = find_team(team_id)
    {
      "team_id" => team.id,
      "franchise_id" => team.franchise_id,
      "team_name" => team.name,
      "abbreviation" => team.abbreviation,
      "link" => team.link
    }
  end

  def most_goals_scored(team_id)
     goals_per_game_per_team[team_id].max
  end

  def rival(team_id)
    find_team(opponents_and_opponent_win_percent_for_team(team_id).max_by {|opponent, win_percentage| win_percentage}[0]).name
  end

  def fewest_goals_scored(team_id)
    goals_per_game_per_team[team_id].min
  end

  def average_win_percentage(team_id)
    win_percentage_per_team[team_id]
  end

  def all_seasons
    @games.map { |game| game.season }.uniq
  end

  def win_percentage_per_team_per_season
    all_seasons.reduce(Hash.new { |h,k| h[k] = {} }) do |result,    season|
     result[season] = games_won_per_team_for_season(season).merge(total_games_per_team_per_season(season)) do |team_id, wins, games|
      (wins.to_f / games).round(2)
     end
     result
    end
  end

  def worst_season(team_id)
    win_percentage_per_team_per_season.min_by { |season, team_win_percent_hash| team_win_percent_hash[team_id]}[0]
  end

  def favorite_opponent(team_id)
    find_team(opponents_and_opponent_win_percent_for_team(team_id).min_by {|opponent, win_percentage| win_percentage}[0]).name
  end

  def worst_coach(season_id)
    percent_wins_by_coach(season_id).min_by do |coach, percent_wins|
      percent_wins
    end[0]
  end

  def best_season(team_id)
    win_percentage_per_team_per_season.max_by { |season, team_win_percent_hash| team_win_percent_hash[team_id]}[0]
  end

end
