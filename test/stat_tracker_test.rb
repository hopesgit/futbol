require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

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

  # def test_it_has_attributes
  #   assert_equal './data/games_fixture.csv', @stat_tracker.game_path
  #   assert_equal './data/teams.csv', @stat_tracker.team_path
  #   assert_equal './data/game_teams_fixture.csv', @stat_tracker.game_teams_path
  # end

  # Game Statistics Tests - Helper Methods #
  def test_it_can_get_total_goals_per_game
    assert_equal 5, @stat_tracker.total_goals_per_game[2012030221]
    assert_equal 3, @stat_tracker.total_goals_per_game[2012030231]
  end

  # Game Statistics Tests - Stat Methods #
  def test_it_can_get_highest_total_score
    assert_equal 7, @stat_tracker.highest_total_score
  end

  def test_count_of_games_by_season
    assert_equal ({20122013=>10, 20142015=>10, 20172018=>10}), @stat_tracker.count_of_games_by_season
  end

  def test_average_goals_per_game
    assert_equal 3.87, @stat_tracker.average_goals_per_game
  end

  def test_it_can_get_total_games_per_team
    expected = { 3=>9, 6=>9, 5=>8, 17=>1, 16=>7, 14=>6, 28=>10, 54=>6, 24=>4 }
    assert_equal expected, @stat_tracker.total_games_per_team
  end

  def test_it_can_exclude_hoa_games_from_total_games_per_team
    total_home_games_per_team = {6=>5, 3=>4, 5=>4, 16=>4, 14=>3, 54=>3, 28=>5, 24=>2}
    exclude = "away"
    assert_equal total_home_games_per_team, @stat_tracker.total_games_per_team(exclude)

    total_away_games_per_team = {3=>5, 6=>4, 5=>4, 17=>1, 16=>3, 14=>3, 28=>5, 54=>3, 24=>2}
    exclude = "home"
    assert_equal total_away_games_per_team, @stat_tracker.total_games_per_team(exclude)
  end

  def test_it_can_get_total_goals_per_team
    expected = {3=>17, 6=>24, 5=>7, 17=>1, 16=>15, 14=>8, 28=>24, 54=>16, 24=>4}
    assert_equal expected, @stat_tracker.total_goals_per_team
  end

  def test_it_can_exclude_hoa_goals_from_total_goals_per_team
    expected_home_goals_per_team = {6=>12, 3=>8, 5=>3, 16=>8, 14=>4, 54=>11, 28=>13, 24=>2}
    exclude = "away"
    assert_equal expected_home_goals_per_team, @stat_tracker.total_goals_per_team(exclude)

    expected_away_goals_per_team = {3=>9, 6=>12, 5=>4, 17=>1, 16=>7, 14=>4, 28=>11, 54=>5, 24=>2}
    exclude = "home"
    assert_equal expected_away_goals_per_team, @stat_tracker.total_goals_per_team(exclude)
  end



  # ==================       League Stats Tests      ==================
end
