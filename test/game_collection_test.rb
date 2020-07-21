require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'
require './lib/game_collection'

class GameCollectionTest < Minitest::Test
  @@game_path = './data/games_fixture.csv'
  @@game_collection = GameCollection.new(@@game_path)

  def test_it_exists
    assert_instance_of GameCollection, @@game_collection
  end

  def test_it_can_return_an_array_of_info
    @@game_collection.all_games
    assert_instance_of Array, @@game_collection.all_games

    assert_equal 30, @@game_collection.all_games.count

    assert_equal true, @@game_collection.all_games.all? { |game| game.class == Game }
  end
end
