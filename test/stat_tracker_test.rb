require './test/helper_test'
require './lib/stat_tracker'
require './lib/helpable'

class StatTrackerTest < Minitest::Test
  include Helpable

  def setup
    game_fixture_path = './data/games_fixture.csv'
    team_fixture_path = './data/teams.csv'
    game_teams_fixture_path = './data/game_teams_fixture.csv'

    fixture_locations = {
    games: game_fixture_path,
    teams: team_fixture_path,
    game_teams: game_teams_fixture_path
    }
    Game.class_variable_set(:@@all_games, [])
    Team.class_variable_set(:@@all_teams, [])
    GameTeam.class_variable_set(:@@all_game_teams, [])
    @stat_tracker = StatTracker.from_csv(fixture_locations)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

# ==================        Helper Methods Tests       ==================

  def test_it_can_read_season_for_game_teams
    assert_equal "20122013", GameTeam.all[1].season
    assert_equal "20172018", GameTeam.all[59].season
  end

  def test_it_can_get_total_games_per_team
    expected = { "3"=>9, "6"=>9, "5"=>8, "17"=>1, "16"=>7, "14"=>6, "28"=>10, "54"=>6, "24"=>4 }

    assert_equal expected, @stat_tracker.total_games_per_team
  end

  def test_it_can_exclude_hoa_games_from_total_games_per_team
    total_home_games_per_team = {"6"=>5, "3"=>4, "5"=>4, "16"=>4, "14"=>3, "54"=>3, "28"=>5, '24'=>2}
    exclude = "away"

    assert_equal total_home_games_per_team, @stat_tracker.total_games_per_team(exclude)

    total_away_games_per_team = {"3"=>5, "6"=>4, "5"=>4, "17"=>1, "16"=>3, "14"=>3, "28"=>5, "54"=>3, "24"=>2}
    exclude = "home"

    assert_equal total_away_games_per_team, @stat_tracker.total_games_per_team(exclude)
  end

  def test_it_can_get_total_goals_per_team
    expected = {"3"=>17, "6"=>24, "5"=>7, "17"=>1, "16"=>15, "14"=>8, "28"=>24, "54"=>16, "24"=>4}

    assert_equal expected, @stat_tracker.total_goals_per_team
  end

  def test_it_can_exclude_hoa_goals_from_total_goals_per_team
    expected_home_goals_per_team = {"6"=>12, "3"=>8, "5"=>3, "16"=>8, "14"=>4, "54"=>11, "28"=>13, "24"=>2}
    exclude = "away"

    assert_equal expected_home_goals_per_team, @stat_tracker.total_goals_per_team(exclude)

    expected_away_goals_per_team = {"3"=>9, "6"=>12, "5"=>4, "17"=>1, "16"=>7, "14"=>4, "28"=>11, "54"=>5, "24"=>2}
    exclude = "home"

    assert_equal expected_away_goals_per_team, @stat_tracker.total_goals_per_team(exclude)
  end

  def test_it_can_get_average_goals_per_game_per_team
    team3 = Team.find("id", "3")
    team5 = Team.find("id", "5")
    team6 = Team.find("id", "6")
    team14 = Team.find("id", "14")
    team16 = Team.find("id", "16")
    team17 = Team.find("id", "17")
    team28 = Team.find("id", "28")
    team24 = Team.find("id", "24")
    team54 = Team.find("id", "54")

    expected = {team3=>1.89, team6=>2.67, team5=>0.88, team17=>1.0, team16=>2.14, team14=>1.33, team28=>2.4, team54=>2.67, team24=>1.0}

    assert_equal expected, @stat_tracker.average_goals_per_game_per_team
  end

  def test_it_can_get_average_goals_per_game_per_team_hoa
    team3 = Team.find("id", "3")
    team5 = Team.find("id", "5")
    team6 = Team.find("id", "6")
    team14 = Team.find("id", "14")
    team16 = Team.find("id", "16")
    team17 = Team.find("id", "17")
    team28 = Team.find("id", "28")
    team24 = Team.find("id", "24")
    team54 = Team.find("id", "54")

    expected_avg_home_goals_p_game_p_team = {team3=>2.0, team6=>2.4, team5=>0.75, team16=>2.0, team14=>1.33, team28=>2.6, team54=>3.67, team24=>1.0}
    exclude = "away"

    assert_equal expected_avg_home_goals_p_game_p_team, @stat_tracker.average_goals_per_game_per_team(exclude)

    expected_avg_away_goals_p_game_p_team = {team14=>1.33, team6=>3.0, team3=>1.8, team5=>1.0, team17=>1.0, team28=>2.2, team16=>2.33, team24=>1.0, team54=>1.67}
    exclude = "home"

    assert_equal expected_avg_away_goals_p_game_p_team, @stat_tracker.average_goals_per_game_per_team(exclude)
  end

  def test_it_can_get_tackles_per_team_for_a_season
    season_20122013_tackles_by_team = {
      "Houston Dynamo" => 179,
      "FC Dallas"	=> 271,
      "Sporting Kansas City"	=> 150,
      "LA Galaxy" => 43,
      "New England Revolution" => 24
    }

    assert_equal season_20122013_tackles_by_team, @stat_tracker.tackles_per_team_for("20122013")
  end

  def test_it_can_find_a_team
    assert_equal "10", @stat_tracker.find_team("3").franchise_id
  end

  def test_it_can_return_games_won_per_team
    teams_to_wins = {
      "3" => 4,
      "5" => 0,
      "6" => 9,
      "16" => 6,
      "17" => 0,
      "14" => 1,
      "28" => 6,
      "54" => 3,
      "24" => 0
    }
    assert_equal teams_to_wins, @stat_tracker.games_won_per_team
  end

  def test_it_can_return_win_percentage_per_team
    teams_to_games = {
      "3" => 0.44,
      "5" => 0.00,
      "6" => 1.00,
      '16' =>	0.86,
      "17" =>	0.00,
      "14" =>	0.17,
      "28" =>	0.60,
      "54" =>	0.50,
      "24" =>	0.00
    }
    assert_equal teams_to_games, @stat_tracker.win_percentage_per_team
  end

  def test_it_can_return_games_for_team
    assert_equal ["2012030221", "2012030222", "2012030223", "2012030224", "2012030225", '2014030131', "2014030132", '2014030133', "2014030134"], @stat_tracker.games_for_team("3").map {|game| game.game_id}
  end

  def test_it_can_return_opponent_by_game_id_for_team
    game_ids_and_opponent = {
      "2012030221"=>"6", "2012030222"=>"6", "2012030223"=>"6", "2012030224"=>"6", "2012030225"=>"6", "2014030131"=>"5", "2014030132"=>"5", "2014030133"=>"5", "2014030134"=>"5"
    }
    assert_equal game_ids_and_opponent, @stat_tracker.opponent_by_game_id_for_team("3")
  end

  def test_it_can_return_result_of_game_for_a_team
    assert_equal true, @stat_tracker.game_result?("LOSS", "3", "2012030221")
  end

  def test_it_can_return_opponents_and_num_result_for_team
    assert_equal ({"6"=>5,"5"=>0}), @stat_tracker.opponents_and_opponents_num_result_for_team("3", "WIN")
  end

  def test_it_can_return_num_games_by_opponent
    assert_equal ({"6"=>5, "5"=>4}), @stat_tracker.num_games_per_opponent_for_team("3")
  end

  def test_it_can_return_opponents_win_percent_for_a_team
    assert_equal ({"6"=>1.0, "5"=>0}), @stat_tracker.opponents_and_opponent_win_percent_for_team("3")
  end

  def test_win_percentage_per_team_per_season
    assert_equal ({"20122013"=>{"6"=>1.0, "16"=>1.0, "3"=>5, "5"=>4, "17"=>1}, "20142015"=>{"16"=>0.83, "14"=>0.17, "3"=>1.0, "5"=>4}, "20172018"=>{"54"=>0.5, "28"=>0.6, "24"=>4}}), @stat_tracker.win_percentage_per_team_per_season
  end

# ==================       Game Stat Methods Tests     ==================

  def test_it_can_get_highest_total_score
    assert_equal 7, @stat_tracker.highest_total_score
  end

  def test_it_can_get_lowest_total_score
    assert_equal 1, @stat_tracker.lowest_total_score
  end

  def test_it_can_calculate_percentage_home_wins
   assert_equal 0.53, @stat_tracker.percentage_home_wins
  end

  def test_it_can_get_visitor_win_percentage
    assert_equal 0.43, @stat_tracker.percentage_visitor_wins
  end

  def test_it_can_get_percentage_ties
    assert_equal 0.03, @stat_tracker.percentage_ties
  end

  def test_count_of_games_by_season
    assert_equal ({"20122013"=>10, "20142015"=>10, "20172018"=>10}), @stat_tracker.count_of_games_by_season
  end

  def test_average_goals_per_game
    assert_equal 3.87, @stat_tracker.average_goals_per_game
  end

  def test_it_can_get_avg_goals_by_season
    seasons_and_avg_goals = {
      "20122013" => 3.70,
      "20142015" => 3.50,
      "20172018" => 4.40
    }
    assert_equal seasons_and_avg_goals, @stat_tracker.average_goals_by_season
  end

  # ==================       League Stat Methods Tests     ==================

  def test_it_can_get_count_of_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_it_can_find_the_best_offensive_team
    assert_equal "FC Dallas", @stat_tracker.best_offense
  end

  def test_it_can_find_the_worst_offensive_team
    assert_equal "Sporting Kansas City", @stat_tracker.worst_offense
  end

  def test_it_can_get_highest_scoring_visitor
    assert_equal "FC Dallas", @stat_tracker.highest_scoring_visitor
  end

  def test_it_can_get_highest_scoring_home_team
    assert_equal "Reign FC", @stat_tracker.highest_scoring_home_team
  end

  def test_it_can_get_lowest_scoring_visitor
    assert_equal "Sporting Kansas City", @stat_tracker.lowest_scoring_visitor
  end

  def test_it_can_get_lowest_scoring_home_team
    assert_equal "Sporting Kansas City", @stat_tracker.lowest_scoring_home_team
  end

  # =================       Season Stat Methods Tests     ==================

  def test_it_can_get_winningest_coach
    assert_equal "Claude Julien", @stat_tracker.winningest_coach("20122013")
  end

  def test_it_can_get_worst_coach_for_a_season
    assert_equal "John Tortorella", @stat_tracker.worst_coach("20122013")
  end

  def test_it_can_find_the_most_accurate_team_per_season
    assert_equal "FC Dallas", @stat_tracker.most_accurate_team("20122013")
    assert_equal "Houston Dynamo", @stat_tracker.most_accurate_team("20142015")
    assert_equal "Reign FC", @stat_tracker.most_accurate_team("20172018")
  end

  def test_it_can_find_the_least_accurate_team_per_season
    assert_equal "Sporting Kansas City", @stat_tracker.least_accurate_team("20122013")
    assert_equal "DC United", @stat_tracker.least_accurate_team("20142015")
    assert_equal "Real Salt Lake", @stat_tracker.least_accurate_team("20172018")
  end

  def test_it_can_return_team_with_most_tackles_in_season
    assert_equal "FC Dallas", @stat_tracker.most_tackles("20122013")
    assert_equal "DC United", @stat_tracker.most_tackles("20142015")
    assert_equal "Los Angeles FC", @stat_tracker.most_tackles("20172018")
  end

  def test_it_can_return_team_with_fewest_tackles_in_season
    assert_equal "New England Revolution", @stat_tracker.fewest_tackles("20122013")

    assert_equal "Sporting Kansas City", @stat_tracker.fewest_tackles("20142015")

    assert_equal "Real Salt Lake", @stat_tracker.fewest_tackles("20172018")
  end

  # ==================       Team Stat Methods Tests     ==================

  def test_it_gets_team_info
    expected = {
                "team_id" => "3",
                "franchise_id" => "10",
                "team_name" => "Houston Dynamo",
                "abbreviation" => "HOU",
                "link" => "/api/v1/teams/3"
                }

    assert_equal expected, @stat_tracker.team_info("3")
  end

  def test_it_can_find_the_best_season_for_a_team
    assert_equal "20122013", @stat_tracker.best_season("3")
  end

  def test_it_can_return_worst_season_for_team
    assert_equal "20172018", @stat_tracker.worst_season("3")
  end

  def test_it_can_get_win_percentage_for_a_team
    assert_equal 0.44, @stat_tracker.average_win_percentage("3")
  end

  def test_it_can_get_most_goals_scored
    assert_equal 3, @stat_tracker.most_goals_scored("14")
    assert_equal 6, @stat_tracker.most_goals_scored("28")
  end

  def test_it_can_get_fewest_goals_scored
    assert_equal 0, @stat_tracker.fewest_goals_scored("14")
    assert_equal 2, @stat_tracker.fewest_goals_scored("16")
  end

  def test_it_can_get_favorite_opponent_for_a_team
    assert_equal "Sporting Kansas City", @stat_tracker.favorite_opponent("3")
  end

  def test_it_can_get_rival_for_a_team
    assert_equal "FC Dallas", @stat_tracker.rival("3")
  end
end
