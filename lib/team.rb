require 'csv'

class Team
  attr_reader :id,
              :franchise_id,
              :name,
              :abbreviation,
              :link
  @@all_teams = []

  def initialize(team_collection_data)
    @id = team_collection_data[:team_id]
    @franchise_id = team_collection_data[:franchiseid]
    @name = team_collection_data[:teamname]
    @abbreviation = team_collection_data[:abbreviation]
    @link = team_collection_data[:link]
  end

  def self.create(team_path)
    CSV.foreach(team_path, headers: true, header_converters: :symbol) do |row|
      @@all_teams << Team.new(row.to_h)
    end
  end

end
