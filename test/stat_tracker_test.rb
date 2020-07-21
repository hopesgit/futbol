require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'
require './lib/game'
require './lib/game_collection'

class StatTrackerTest < Minitest::Test

  def setup
    game_fixture_path = './data/games_fixture.csv'
    team_fixture_path = './data/teams.csv'
    game_teams_fixture_path = './data/game_teams_fixture.csv'

    @fixture_locations = {
    games: game_fixture_path,
    teams: team_fixture_path,
    game_teams: game_teams_fixture_path
    }

    @stat_tracker = StatTracker.from_csv(@fixture_locations)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_has_attributes
    assert_instance_of GameCollection, @stat_tracker.game_collection
    assert_equal TeamCollection, @stat_tracker.team_path
    assert_equal GameTeamCollection @stat_tracker.game_teams_path
  end

  # Game Statistics Tests - Helper Methods #
  def test_it_can_get_total_goals_per_game
    assert_equal 5, @stat_tracker.total_goals_per_game[2012030221]
    assert_equal 3, @stat_tracker.total_goals_per_game[2012030231]
  end

  # Game Statistics Tests - Stat Methods #
  def test_it_can_get_highest_total_score
    assert 5, @stat_tracker.highest_total_score
  end

  def test_count_of_games_by_season
    assert_equal ({20122013 => 20}), @stat_tracker.count_of_games_by_season
  end

  def test_average_goals_per_game
    assert_equal 3.75, @stat_tracker.average_goals_per_game
  end


end
