require_relative './game'
require 'csv'

class GameCollection
  attr_reader :game_collection

  def initialize(game_path)
    @game_path = './data/games_fixture.csv'
    @game_collection = all_games
  end

  def all_games
    all_games = []
    CSV.foreach(@game_path, headers: true, converters: :numeric, header_converters: :symbol) do |row|
      all_games << Game.new(row.to_h)
    end
    all_games
  end

end
