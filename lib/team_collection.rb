require 'csv'
require './lib/team'

class TeamCollection
  attr_reader :teams

  def initialize(teams_data_input)
    @teams_csv = teams_data_input
    @teams = []
  end

  def create_teams
    csv = CSV.read(@teams_csv, headers: true, converters: :numeric, header_converters: :symbol)
    csv.map do |row|
      @teams << Team.new(row.to_h)
    end
  end
end
