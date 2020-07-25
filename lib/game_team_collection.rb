require_relative './game_team'
require 'csv'

class GameTeamCollection

  attr_reader :all_game_teams

  def initialize(game_team_path)
    @game_team_path = game_team_path
    @all_game_teams = []
    create_game_teams
  end

  def create_game_teams
    CSV.foreach(@game_team_path, headers: true, header_converters: :symbol) do |row|
      game_team = GameTeam.new(row.to_h)
      @all_game_teams << game_team
      game_team.season = generate_season(game_team.game_id)
    end
  end

  def generate_season(game_id)
    "#{game_id.slice(0, 4)}#{(game_id.slice(0, 4)).to_i + 1}"
  end
end
