require 'csv'
require_relative './helpable'
require_relative './data_set'

class Team < DataSet
  extend Helpable
  attr_reader :id,
              :franchise_id,
              :name,
              :abbreviation,
              :link
  @@all_teams = []

  def self.all
    @@all_teams
  end

  def initialize(team_collection_data)
    @id = team_collection_data[:team_id]
    @franchise_id = team_collection_data[:franchiseid]
    @name = team_collection_data[:teamname]
    @abbreviation = team_collection_data[:abbreviation]
    @link = team_collection_data[:link]
  end

  def self.average_win_percentage(team_id)
    win_percentage_per_team[team_id]
  end

  def self.best_season(team_id)
    win_percentage_per_team_per_season.max_by { |season, team_win_percent_hash| team_win_percent_hash[team_id]}[0]
  end

  def self.worst_season(team_id)
    win_percentage_per_team_per_season.min_by { |season, team_win_percent_hash| team_win_percent_hash[team_id]}[0]
  end

  def self.rival(team_id)
    find_team(opponents_and_opponent_win_percent_for_team(team_id).max_by {|opponent, win_percentage| win_percentage}[0]).name
  end

  def self.favorite_opponent(team_id)
    find_team(opponents_and_opponent_win_percent_for_team(team_id).min_by {|opponent, win_percentage| win_percentage}[0]).name
  end
end
