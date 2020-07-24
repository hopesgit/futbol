require_relative './game_team'
require 'csv'

class GameTeamCollection

  attr_reader :all_game_teams

  def initialize(game_team_path, all_gameids_per_season)
    @game_team_path = game_team_path
    @all_game_teams = []
    @all_gameids_per_season = all_gameids_per_season
    create_game_teams
  end

  def create_game_teams
    CSV.foreach(@game_team_path, headers: true, header_converters: :symbol) do |row|
      game_team = GameTeam.new(row.to_h)
      @all_game_teams << game_team
      @all_gameids_per_season.each do |season, game_ids|
        if game_ids.include?(game_team.game_id)
          game_team.season = season
        end
      end
    end
  end
end
