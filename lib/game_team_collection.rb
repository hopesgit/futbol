require 'csv'

class GameTeamCollection
  def initialize(game_team_path)
    @game_team_path = game_team_path
    @game_team_collection = all_game_teams
  end

  def all_game_teams
    game_team_array = []
    CSV.foreach(@game_team_path, headers: true, converters: :numeric, header_converters: :symbol) do |row|
      game_team_array << GameTeam.new(row.to_h)
    end
    game_team_array
  end
end
