require 'csv'
require './lib/team'

class TeamCollection
  attr_reader :teams

  def initialize(teams_path)
    @teams_csv = teams_path
    @team_collection = all_teams
  end

  def all_teams
    all_teams = []
    CSV.foreach(@teams_csv, headers: true, converters: :numeric, header_converters: :symbol) do |row|
      all_teams << Team.new(row.to_h)
    end
    all_teams
  end
end
