require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'
require './lib/game_collection'

class GameCollectionTest < Minitest::Test

  def setup
    file = './data/games_fixture.csv'
    @game_collection = GameCollection.new(file)
  end

  def test_it_exists
    assert_instance_of GameCollection, @game_collection
  end

  def test_average_goals_per_game
    assert_equal 3.75, @game_collection.average_goals_per_game
  end

  def test_count_of_games_by_season
    assert_equal ({20122013 => 20}), @game_collection.count_of_games_by_season
  end

end
