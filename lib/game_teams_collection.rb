require 'csv'

class GameTeamsCollection
  def initialize(game_teams_path)
    @game_teams_path = game_teams_path
    @game_teams_collection = all_game_teams
  end

  def all_game_teams
    game_teams_array = []
    CSV.foreach(@game_teams_path, headers: true, converters: :numeric, header_converters: :symbol) do |row|
      game_teams_array << GameTeams.new(row.to_h)
    end
  end
end
