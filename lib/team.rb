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

  def self.team_info(team_id)
    team = find_team(team_id)
    { "team_id" => team.id,
      "franchise_id" => team.franchise_id,
      "team_name" => team.name,
      "abbreviation" => team.abbreviation,
      "link" => team.link
    }
  end
end
