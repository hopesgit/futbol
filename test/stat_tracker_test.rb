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
  # def test_it_can_get_total_goals_per_game 
  #   assert_equal 5, @stat_tracker.total_goals_per_game[2012030221]
  #   assert_equal 3, @stat_tracker.total_goals_per_game[2012030231]
  # end

  # def test_it_can_get_total_goals_per_game_per_season 
  #   seasons_and_goals_per_game = { 
  #     20122013 => [5, 5, 3, 5, 4, 3, 5, 3, 1, 3],
  #     20142015 => [3, 5, 5,	3, 3,	2, 3, 5, 3, 3],
  #     20172018 => [5, 5, 5, 2, 6, 3, 3, 5, 7, 3]
  #   }

  #   assert_equal seasons_and_goals_per_game, @stat_tracker.total_goals_per_game_per_season 
  # end

  def test_it_can_get_total_goals_per_season 
    seasons_and_goals_per_game = { 
      20122013 => [5, 5, 3, 5, 4, 3, 5, 3, 1, 3],
      20142015 => [3, 5, 5,	3, 3,	2, 3, 5, 3, 3],
      20172018 => [5, 5, 5, 2, 6, 3, 3, 5, 7, 3]
    }

    assert_equal seasons_and_goals_per_game, @stat_tracker.total_goals_per_game_or_season(:season)
  end

# Game Statistics Tests - Stat Methods #
  def test_it_can_get_highest_total_score
    skip
    assert_equal 7, @stat_tracker.highest_total_score 
  end

  def test_it_can_get_avg_goals_by_season
    skip
    seasons_and_avg_goals = { 
      20122013 => 3.70,
      20142015 => 3.50,
      20172018 => 4.40
    }
    assert seasons_and_avg_goals, @stat_tracker.average_goals_by_season
  end
end