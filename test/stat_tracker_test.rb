require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  def setup
    game_fixture_path = './data/games_fixture.csv'
    team_fixture_path = './data/teams_fixture.csv'
    game_teams_fixture_path = './data/game_teams_fixture.csv'

    fixture_locations = {
    games: game_fixture_path,
    teams: team_fixture_path,
    game_teams: game_teams_fixture_path
    }

    @stat_tracker = StatTracker.from_csv(fixture_locations)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_has_attributes
    assert_equal './data/games_fixture.csv', @stat_tracker.game_path
    assert_equal './data/teams_fixture.csv', @stat_tracker.team_path
    assert_equal './data/game_teams_fixture.csv', @stat_tracker.game_teams_path
  end

# Game Statistics Tests - Helper Methods #
  def test_it_can_get_total_goals_per_game 
    assert_equal 5, @stat_tracker.total_goals[:2012030221]
  end

# Game Statistics Tests - Stat Methods #

end
