require 'minitest/autorun'
require 'minitest/pride'
require './lib/data_set'
require './lib/team'
require './lib/game_team'
require './lib/game'

class DataSetTest < Minitest::Test
  def setup
    @set = DataSet.new()
    Team.create('./data/teams.csv')
    Game.create('./data/games_fixture.csv')
    GameTeam.create('./data/game_teams_fixture.csv')
  end

  def test_it_exists
    assert_instance_of DataSet, @set
  end

end
