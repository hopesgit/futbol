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

end
