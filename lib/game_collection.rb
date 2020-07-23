require_relative './game'
require 'csv'

class GameCollection
  attr_reader :all_games

  def initialize(game_path)
    @game_path = game_path
    @all_games = []
    create_games
  end

  def create_games
    CSV.foreach(@game_path, headers: true, converters: :numeric, header_converters: :symbol) do |row|
      all_games << Game.new(row.to_h)
    end
  end

end
