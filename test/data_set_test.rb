require 'minitest/autorun'
require 'minitest/pride'
require './lib/data_set'
require './lib/team'
require './lib/game'


class DataSetTest < Minitest::Test
  def test_test
    set = DataSet.new()
    Team.create('./data/teams.csv')
    Game.create('./data/games_fixture.csv')
  end
end
