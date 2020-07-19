require 'csv'

class GameTeamCollection

  attr_reader :all_game_teams

  def initialize(game_team_path)
    @game_team_path = game_team_path
    @all_game_teams = []
    create_game_teams
  end

  def create_game_teams
    CSV.foreach(@game_team_path, headers: true, converters: :numeric, header_converters: :symbol) do |row|
      @all_game_teams << GameTeam.new(row.to_h)
    end
  end
end
