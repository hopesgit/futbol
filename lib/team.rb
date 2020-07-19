class Team
  attr_reader :id, :name, :abbreviation, :stadium, :link

  def initialize(team_collection_data)
    @id = team_collection_data[:team_id]
    @franchise_id = team_collection_data[:franchiseid]
    @name = team_collection_data[:teamname]
    @abbreviation = team_collection_data[:abbreviation]
    @stadium = team_collection_data[:stadium]
    @link = team_collection_data[:link]
  end
end