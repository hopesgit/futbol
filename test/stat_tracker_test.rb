require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
    game_fixture_path = './data/games_fixture.csv'
    team_fixture_path = './data/teams.csv'
    game_teams_fixture_path = './data/game_teams_fixture.csv'

    fixture_locations = {
    games: game_fixture_path,
    teams: team_fixture_path,
    game_teams: game_teams_fixture_path
    }

    @@stat_tracker = StatTracker.from_csv(fixture_locations)

  def test_it_exists
    assert_instance_of StatTracker, @@stat_tracker
  end

  def test_it_has_attributes
    assert_instance_of Array, @@stat_tracker.games
    assert_instance_of Array, @@stat_tracker.teams
    assert_instance_of Array, @@stat_tracker.game_teams
  end

# ==================        Helper Methods Tests       ==================

  def test_it_can_get_seasons
    assert_equal [20122013, 20142015, 20172018], @@stat_tracker.seasons
  end

  def test_it_can_get_total_goals_per_game
    assert_equal 5, @@stat_tracker.total_goals_per_game[2012030221]
    assert_equal 3, @@stat_tracker.total_goals_per_game[2012030231]
  end

  def test_it_can_get_total_number_of_games
    assert_equal 30, @@stat_tracker.total_games
  end

  def test_it_can_get_total_wome_wins
    assert_equal 16, @@stat_tracker.total_home_wins
  end

  def test_it_can_get_total_tied_games
    assert_equal 1, @@stat_tracker.total_tied_games
  end

  def test_it_can_read_season_for_game_teams
    assert_equal 20122013, @@stat_tracker.game_teams[1].season
    assert_equal 20172018, @@stat_tracker.game_teams[59].season
  end

# ==================       Game Stat Methods Tests     ==================

  def test_it_can_return_total_goals_per_season
    seasons_and_total_goals = {
      20122013 => 37,
      20142015 => 35,
      20172018 => 44
    }

    assert_equal seasons_and_total_goals, @@stat_tracker.total_goals_per_season
  end

  def test_it_can_get_away_wins
    assert_equal 13, @@stat_tracker.total_away_wins
  end
  def test_it_can_get_highest_total_score
    assert_equal 7, @@stat_tracker.highest_total_score
  end

  def test_it_can_calculate_percentage_home_wins
   assert_equal 53.33, @@stat_tracker.percentage_home_wins
  end

  def test_it_can_get_percentage_ties
    assert_equal 3.33, @@stat_tracker.percentage_ties
  end

  def test_it_can_get_lowest_total_score
    assert_equal 1, @@stat_tracker.lowest_total_score
  end

  def test_it_can_get_visitor_win_percentage
    assert_equal 43.33, @@stat_tracker.percentage_visitor_wins
  end

  def test_count_of_games_by_season
    assert_equal ({20122013=>10, 20142015=>10, 20172018=>10}), @@stat_tracker.count_of_games_by_season
  end

  def test_average_goals_per_game
    assert_equal 3.87, @@stat_tracker.average_goals_per_game
  end

  def test_it_can_get_avg_goals_by_season
    seasons_and_avg_goals = {
      20122013 => 3.70,
      20142015 => 3.50,
      20172018 => 4.40
    }
    assert_equal seasons_and_avg_goals, @@stat_tracker.average_goals_by_season
  end

  # ==================       League Stat Methods Tests     ==================

  def test_it_can_get_count_of_teams 
    assert_equal 32, @@stat_tracker.count_of_teams
  end
end