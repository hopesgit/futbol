require 'minitest/autorun'
require 'minitest/pride'
require './lib/game_teams_collection'

class GameTeamsTest < Minitest::Test
  def setup
    @game_teams_path = './data/game_teams_fixture.csv'
    @game_teams_collection = GameTeamsCollection.new(@game_teams_path)
  end

  def test_it_exists
    assert_instance_of GameTeamsCollection, @game_teams_collection
  end
end
