require_relative './game'
require 'csv'

class GameCollection
  attr_reader :all_games,
              :all_gameids_per_season

  def initialize(game_path)
    @game_path = game_path
    @all_games = []
    @all_gameids_per_season = Hash.new { |h,k| h[k] = [] }
    create_games
  end

  def create_games
    CSV.foreach(@game_path, headers: true, converters: :numeric, header_converters: :symbol) do |row|
      all_games << Game.new(row.to_h)
      all_gameids_per_season[row[:season]] << row[:game_id]
    end
  end

end
