require 'minitest/autorun'
require 'minitest/pride'
require './lib/game_team_collection'
require './lib/game_team'
require './lib/game_collection'

class GameTeamCollectionTest < Minitest::Test
  game_path = './data/games_fixture.csv'
  game_collection = GameCollection.new(game_path)
  all_gameids_per_season = game_collection.all_gameids_per_season
  game_team_path = './data/game_teams_fixture.csv'
  @@game_team_collection = GameTeamCollection.new(game_team_path, all_gameids_per_season)

  def test_it_exists
    assert_instance_of GameTeamCollection, @@game_team_collection
  end

  def test_it_can_return_an_array_all_game_teams
    assert_instance_of Array, @@game_team_collection.all_game_teams
    assert_equal 60, @@game_team_collection.all_game_teams.size
    assert @@game_team_collection.all_game_teams.all? { |game_team| game_team.class == GameTeam}
  end

  def test_it_can_add_season_id
    assert_equal "20122013", @@game_team_collection.all_game_teams[1].season
    assert_equal "20172018",  @@game_team_collection.all_game_teams[59].season
  end
end
