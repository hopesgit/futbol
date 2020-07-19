require 'minitest/autorun'
require 'minitest/pride'
require './lib/game_team_collection'
require './lib/game_team'

class GameTeamCollectionTest < Minitest::Test
  def setup
    @game_team_path = './data/game_teams_fixture.csv'
    @game_team_collection = GameTeamCollection.new(@game_team_path)
  end

  def test_it_exists
    assert_instance_of GameTeamCollection, @game_team_collection
  end

  def test_it_can_return_an_array_all_game_teams
    assert_instance_of Array, @game_team_collection.all_game_teams
    assert_equal 20, @game_team_collection.all_game_teams.size
    assert @game_team_collection.all_game_teams.all? { |game_team| game_team.class == GameTeam}
  end
end
