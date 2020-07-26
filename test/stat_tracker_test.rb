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
    assert_equal ["20122013", "20142015", "20172018"], @@stat_tracker.seasons
  end

  def test_it_can_get_total_goals_per_game
    assert_equal 5, @@stat_tracker.total_goals_per_game["2012030221"]
    assert_equal 3, @@stat_tracker.total_goals_per_game["2012030231"]
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
    assert_equal "20122013", @@stat_tracker.game_teams[1].season
    assert_equal "20172018", @@stat_tracker.game_teams[59].season
  end

  def test_it_can_get_total_games_per_team
    expected = { "3"=>9, "6"=>9, "5"=>8, "17"=>1, "16"=>7, "14"=>6, "28"=>10, "54"=>6, "24"=>4 }

    assert_equal expected, @@stat_tracker.total_games_per_team
  end

  def test_it_can_exclude_hoa_games_from_total_games_per_team
    total_home_games_per_team = {"6"=>5, "3"=>4, "5"=>4, "16"=>4, "14"=>3, "54"=>3, "28"=>5, '24'=>2}
    exclude = "away"

    assert_equal total_home_games_per_team, @@stat_tracker.total_games_per_team(exclude)

    total_away_games_per_team = {"3"=>5, "6"=>4, "5"=>4, "17"=>1, "16"=>3, "14"=>3, "28"=>5, "54"=>3, "24"=>2}
    exclude = "home"

    assert_equal total_away_games_per_team, @@stat_tracker.total_games_per_team(exclude)
  end

  def test_it_can_get_total_goals_per_team
    expected = {"3"=>17, "6"=>24, "5"=>7, "17"=>1, "16"=>15, "14"=>8, "28"=>24, "54"=>16, "24"=>4}

    assert_equal expected, @@stat_tracker.total_goals_per_team
  end

  def test_it_can_exclude_hoa_goals_from_total_goals_per_team
    expected_home_goals_per_team = {"6"=>12, "3"=>8, "5"=>3, "16"=>8, "14"=>4, "54"=>11, "28"=>13, "24"=>2}
    exclude = "away"

    assert_equal expected_home_goals_per_team, @@stat_tracker.total_goals_per_team(exclude)

    expected_away_goals_per_team = {"3"=>9, "6"=>12, "5"=>4, "17"=>1, "16"=>7, "14"=>4, "28"=>11, "54"=>5, "24"=>2}
    exclude = "home"

    assert_equal expected_away_goals_per_team, @@stat_tracker.total_goals_per_team(exclude)
  end

  def test_it_can_get_average_goals_per_game_per_team
    team3 = @@stat_tracker.teams.find { |team| team.id == "3" }
    team5 = @@stat_tracker.teams.find { |team| team.id == "5" }
    team6 = @@stat_tracker.teams.find { |team| team.id == "6" }
    team14 = @@stat_tracker.teams.find { |team| team.id == "14" }
    team16 = @@stat_tracker.teams.find { |team| team.id == "16" }
    team17 = @@stat_tracker.teams.find { |team| team.id == "17" }
    team28 = @@stat_tracker.teams.find { |team| team.id == "28" }
    team24 = @@stat_tracker.teams.find { |team| team.id == "24" }
    team54 = @@stat_tracker.teams.find { |team| team.id == "54" }

    expected = {team3=>1.89, team6=>2.67, team5=>0.88, team17=>1.0, team16=>2.14, team14=>1.33, team28=>2.4, team54=>2.67, team24=>1.0}

    assert_equal expected, @@stat_tracker.average_goals_per_game_per_team
  end

  def test_it_can_get_average_goals_per_game_per_team_hoa
    team3 = @@stat_tracker.teams.find { |team| team.id == "3" }
    team5 = @@stat_tracker.teams.find { |team| team.id == "5" }
    team6 = @@stat_tracker.teams.find { |team| team.id == "6" }
    team14 = @@stat_tracker.teams.find { |team| team.id == "14" }
    team16 = @@stat_tracker.teams.find { |team| team.id == "16" }
    team17 = @@stat_tracker.teams.find { |team| team.id == "17" }
    team28 = @@stat_tracker.teams.find { |team| team.id == "28" }
    team24 = @@stat_tracker.teams.find { |team| team.id == "24" }
    team54 = @@stat_tracker.teams.find { |team| team.id == "54" }

    expected_avg_home_goals_p_game_p_team = {team3=>2.0, team6=>2.4, team5=>0.75, team16=>2.0, team14=>1.33, team28=>2.6, team54=>3.67, team24=>1.0}
    exclude = "away"

    assert_equal expected_avg_home_goals_p_game_p_team, @@stat_tracker.average_goals_per_game_per_team(exclude)

    expected_avg_away_goals_p_game_p_team = {team14=>1.33, team6=>3.0, team3=>1.8, team5=>1.0, team17=>1.0, team28=>2.2, team16=>2.33, team24=>1.0, team54=>1.67}
    exclude = "home"

    assert_equal expected_avg_away_goals_p_game_p_team, @@stat_tracker.average_goals_per_game_per_team(exclude)
  end

  def test_it_can_get_tackles_per_team_for_a_season
    season_20122013_tackles_by_team = {
      "Houston Dynamo" => 179,
      "FC Dallas"	=> 271,
      "Sporting Kansas City"	=> 150,
      "LA Galaxy" => 43,
      "New England Revolution" => 24
    }

    assert_equal season_20122013_tackles_by_team, @@stat_tracker.tackles_per_team_for("20122013")
  end

  def test_it_can_find_a_team
    assert_equal "10", @@stat_tracker.find_team("3").franchise_id
  end

  def test_it_can_get_goals_per_game_per_team

    expected = {
                "3"=>[2, 2, 1, 2, 1, 2, 3, 2, 2],
                "6"=>[3, 3, 2, 3, 3, 3, 4, 2, 1],
                "5"=>[0, 1, 1, 0, 1, 2, 1, 1],
                "17"=>[1],
                "16"=>[2, 2, 3, 2, 2, 2, 2],
                "14"=>[1, 2, 3, 1, 1, 0],
                "28"=>[0, 2, 3, 2, 3, 0, 3, 3, 6, 2],
                "54"=>[5, 3, 2, 0, 3, 3],
                "24"=>[0, 2, 1, 1]
              }

    assert_equal expected, @@stat_tracker.goals_per_game_per_team
  end

  def test_it_can_get_shots_per_team
    shots_fired = {
      "3" => 65,
      "6" => 76,
      "5" => 54,
      "17" => 5,
      "16" => 50,
      "14" => 39,
      "28" => 82,
      "54" => 48,
      "24" => 31
    }
    assert_equal shots_fired, @@stat_tracker.total_shots_per_team
  end

  def test_shots_to_goals_ratio_per_team
    ratio = {
      "3" => 3.82,
      "6" => 3.17,
      "5" => 7.71,
      "17" => 5.00,
      "16" => 3.33,
      "14" => 4.88,
      "28" => 3.42,
      "54" => 3.00,
      "24" => 7.75
    }
    assert_equal ratio, @@stat_tracker.shots_to_goals_ratio_per_team
  end

  def test_it_can_return_games_won_per_team_for_a_season
    assert_equal ({"6"=>9, "16"=>1}), @@stat_tracker.games_won_per_team_for_season("20122013")
  end

  def test_it_can_return_total_games_per_team_for_a_season
    assert_equal ({"3"=>5, "6"=>9, "5"=>4, "17"=>1, "16"=>1}), @@stat_tracker.total_games_per_team_for_season("20122013")
  end

  def test_it_can_get_game_teams_by_coach_for_season
    assert_instance_of Hash, @@stat_tracker.game_teams_by_coach_for_season("20122013")
    assert_equal 5, @@stat_tracker.game_teams_by_coach_for_season("20122013").length
  end

  def test_it_can_get_number_of_games_by_coach
    expected = {"John Tortorella"=>5, "Claude Julien"=>9, "Dan Bylsma"=>4, "Mike Babcock"=>1, "Joel Quenneville"=>1}
    assert_equal expected, @@stat_tracker.number_of_games_by_coach("20122013")
  end

  def test_it_can_get_all_wins_by_coach
    expected = {"John Tortorella"=>0, "Claude Julien"=>9, "Dan Bylsma"=>0, "Mike Babcock"=>0, "Joel Quenneville"=>1}
    assert_equal expected, @@stat_tracker.find_all_wins_by_coach("20122013")
  end

  def test_percent_wins_by_coach
    assert_equal ({"John Tortorella"=>0.0, "Claude Julien"=>1.0, "Dan Bylsma"=>0.0, "Mike Babcock"=>0.0, "Joel Quenneville"=>1.0}),
    @@stat_tracker.percent_wins_by_coach("20122013")
  end


# ==================       Game Stat Methods Tests     ==================

  def test_it_can_return_total_goals_per_season
    seasons_and_total_goals = {
      "20122013" => 37,
      "20142015" => 35,
      "20172018" => 44
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
   assert_equal 0.53, @@stat_tracker.percentage_home_wins
  end

  def test_it_can_get_percentage_ties
    assert_equal 0.03, @@stat_tracker.percentage_ties
  end

  def test_it_can_get_lowest_total_score
    assert_equal 1, @@stat_tracker.lowest_total_score
  end

  def test_it_can_get_visitor_win_percentage
    assert_equal 0.43, @@stat_tracker.percentage_visitor_wins
  end

  def test_count_of_games_by_season
    assert_equal ({"20122013"=>10, "20142015"=>10, "20172018"=>10}), @@stat_tracker.count_of_games_by_season
  end

  def test_average_goals_per_game
    assert_equal 3.87, @@stat_tracker.average_goals_per_game
  end

  def test_it_can_get_avg_goals_by_season
    seasons_and_avg_goals = {
      "20122013" => 3.70,
      "20142015" => 3.50,
      "20172018" => 4.40
    }
    assert_equal seasons_and_avg_goals, @@stat_tracker.average_goals_by_season
  end

  # ==================       League Stat Methods Tests     ==================

  def test_it_can_find_the_best_offensive_team
    assert_equal "FC Dallas", @@stat_tracker.best_offense
  end

  def test_it_can_get_highest_scoring_visitor
    assert_equal "FC Dallas", @@stat_tracker.highest_scoring_visitor
  end

  def test_it_can_get_lowest_scoring_visitor
    assert_equal "Sporting Kansas City", @@stat_tracker.lowest_scoring_visitor
  end

  def test_it_can_get_highest_scoring_home_team
    assert_equal "Reign FC", @@stat_tracker.highest_scoring_home_team
  end

  def test_it_can_get_count_of_teams
    assert_equal 32, @@stat_tracker.count_of_teams
  end

  def test_it_can_find_the_worst_offensive_team
    assert_equal "Sporting Kansas City", @@stat_tracker.worst_offense
  end

  def test_it_can_get_lowest_scoring_home_team
    assert_equal "Sporting Kansas City", @@stat_tracker.lowest_scoring_home_team
  end

  def test_it_can_get_winningest_coach
    assert_equal "Claude Julien", @@stat_tracker.winningest_coach("20122013")
  end

  def test_it_can_return_team_with_fewest_tackles_in_season
    assert_equal "New England Revolution", @@stat_tracker.fewest_tackles("20122013")

    assert_equal "Sporting Kansas City", @@stat_tracker.fewest_tackles("20142015")

    assert_equal "Real Salt Lake", @@stat_tracker.fewest_tackles("20172018")
  end

  def test_it_can_return_team_with_most_tackles_in_season
    assert_equal "FC Dallas", @@stat_tracker.most_tackles("20122013")

    assert_equal "DC United", @@stat_tracker.most_tackles("20142015")

    assert_equal "Los Angeles FC", @@stat_tracker.most_tackles("20172018")
  end

  # ==================       Team Stat Methods Tests     ==================

  def test_it_gets_team_info
    expected = {
                id: "3",
                franchise_id: "10",
                name: "Houston Dynamo",
                abbreviation: "HOU",
                link: "/api/v1/teams/3"
                }

    assert_equal expected, @@stat_tracker.team_info("3")
  end

  def test_it_can_get_most_goals_scored
    assert_equal 3, @@stat_tracker.most_goals_scored("14")
    assert_equal 6, @@stat_tracker.most_goals_scored("28")
  end

  def test_it_can_get_games_won_per_team
    assert_equal ({"3"=>4, "6"=>9, "5"=>0, "17"=>0, "16"=>6, "14"=>1, "28"=>6, "54"=>3, "24"=>0}), @@stat_tracker.games_won_per_team
  end

  def test_it_can_get_win_percentage_per_team
    assert_equal ({"3"=>0.44, "6"=>1.0, "5"=>0.0, "17"=>0.0, "16"=>0.86, "14"=>0.17, "28"=>0.6, "54"=>0.5, "24"=>0.0}), @@stat_tracker.win_percentage_per_team
  end

  def test_it_can_get_average_win_percentage_per_team
    assert_equal (0.44), @@stat_tracker.average_win_percentage("3")
  end

  def test_it_can_get_win_count_by_season
    assert_equal ({}), @@stat_tracker.worst_season("3")
  end

end
