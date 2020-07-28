require 'csv'

class Team < DataSet
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
end
