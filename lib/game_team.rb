require 'csv'
require_relative './helpable'

class GameTeam
  include Helpable

  attr_reader :game_id,
              :team_id,
              :hoa,
              :result,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :tackles
  @@all_game_teams = []

  attr_accessor :season

  def initialize(data)
    @game_id = data[:game_id]
    @team_id = data[:team_id]
    @hoa = data[:hoa]
    @result = data[:result]
    @settled_in = data[:settled_in]
    @head_coach = data[:head_coach]
    @goals = data[:goals].to_i
    @shots = data[:shots].to_i
    @tackles = data[:tackles].to_i
    @season = nil
  end

  def generate_season(game_id)
    "#{game_id.slice(0, 4)}#{(game_id.slice(0, 4)).to_i + 1}"
  end

  def self.create(game_team_path)
    CSV.foreach(game_team_path, headers: true, header_converters: :symbol) do |row|
      game_team = GameTeam.new(row.to_h)
      @@all_game_teams << game_team
      game_team.season = game_team.generate_season(game_team.game_id)
    end
  end

  def self.total_home_wins
    @@all_game_teams.find_all do |game_team|
      game_team.hoa == "home" && game_team.result == "WIN"
    end.size
   end
end