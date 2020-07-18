require_relative './game'
require 'csv'

class GameCollection
  attr_reader :game_collection

  def initialize(game_path)
    @game_collection = create_games(game_path)
  end

  def create_games(game_path)
    all_games = []
    csv = CSV.foreach(game_path, headers: true, converters: :numeric, header_converters: :symbol)
    csv.map do |row|
      all_games << Game.new(row.to_h)
    end
    all_games
  end

end
