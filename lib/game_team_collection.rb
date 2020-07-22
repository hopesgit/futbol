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
    CSV.foreach(@game_team_path, headers: true, converters: :numeric, header_converters: :symbol) do |row|
      @all_game_teams << GameTeam.new(row.to_h)
    end
  end

  def add_season_id(games)
    @all_game_teams.each do |game_team|
      games.each do |game|
        if game_team.game_id == game.game_id
          game_team.season = game.season
        end
      end
    end
  end
end
