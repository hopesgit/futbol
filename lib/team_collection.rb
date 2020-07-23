require 'csv'
require_relative './team'

class TeamCollection
  attr_reader :all_teams

  def initialize(teams_path)
    @teams_csv = teams_path
    @all_teams = []
    create_teams
  end

  def create_teams
    CSV.foreach(@teams_csv, headers: true, converters: :numeric, header_converters: :symbol) do |row|
      all_teams << Team.new(row.to_h)
    end
  end
end
