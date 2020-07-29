require './test/helper_test'
require './lib/game_team'
require './lib/mathable'

class GameTeamTest < Minitest::Test
  include Mathable
  def setup
    @game_team = GameTeam.new({
                                :game_id=>"2012030221",
                                :team_id=>"3",
                                :hoa=>"away",
                                :result=>"LOSS",
                                :head_coach=>"John Tortorella",
                                :goals=>2,
                                :shots=>8,
                                :tackles=>44
                                })

    @game_team.season = "20122013"
    GameTeam.class_variable_set(:@@all_game_teams, [])
    GameTeam.create('./data/game_teams_fixture.csv')
  end

  def test_it_exists
    assert_instance_of GameTeam, @game_team
  end

  def test_it_has_readable_attributes
    assert_equal "2012030221", @game_team.game_id
    assert_equal "3", @game_team.team_id
    assert_equal "away", @game_team.hoa
    assert_equal "LOSS", @game_team.result
    assert_equal "John Tortorella", @game_team.head_coach
    assert_equal 2, @game_team.goals
    assert_equal 8, @game_team.shots
    assert_equal 44, @game_team.tackles
    assert_equal "20122013", @game_team.season
  end

  def test_it_can_return_an_array_of_info
    assert_instance_of Array, GameTeam.class_variable_get(:@@all_game_teams)
    assert_equal 60, GameTeam.class_variable_get(:@@all_game_teams).count
    assert_equal true, GameTeam.class_variable_get(:@@all_game_teams).all? { |game_team| game_team.class == GameTeam }
  end

  def test_it_can_add_season_id
    assert_equal "20122013", GameTeam.class_variable_get(:@@all_game_teams)[1].season
    assert_equal "20172018",  GameTeam.class_variable_get(:@@all_game_teams)[59].season
  end

  def test_it_can_generate_a_season_id
    assert_equal "20122013", @game_team.generate_season("2012030225")
    assert_equal "20142015", @game_team.generate_season("2014030413")
  end

  def test_it_can_get_total_home_wins
    assert_equal 16, GameTeam.total_home_wins
  end

  def test_it_can_get_total_goals_per_team_for_a_season
    assert_equal ({"3"=>8, "6"=>24, "5"=>2, "17"=>1, "16"=>2}), GameTeam.total_goals_per_team_for_season("20122013")
  end

  def test_it_can_get_shots_per_team
    shots_fired = {
      "3" => 38,
      "6" => 76,
      "5" => 32,
      "17" => 5,
      "16" => 10,
    }
    assert_equal shots_fired, GameTeam.total_shots_per_team_for_season("20122013")
  end

  def test_shots_to_goals_ratio_per_team
    ratio = {
      "3" => 4.75,
      "6" => 3.167,
      "5" => 16.0,
      "17" => 5.00,
      "16" => 5.00,
    }
    assert_equal ratio, GameTeam.shots_to_goals_ratio_per_team_for_season("20122013")
  end

  def test_it_can_get_game_teams_by_coach_for_season
    assert_instance_of Hash, GameTeam.game_teams_by_coach_for_season("20122013")
    assert_equal 5, GameTeam.game_teams_by_coach_for_season("20122013").length
  end

  def test_it_can_get_number_of_games_by_coach_for_a_season
    expected = {"John Tortorella"=>5, "Claude Julien"=>9, "Dan Bylsma"=>4, "Mike Babcock"=>1, "Joel Quenneville"=>1}
    assert_equal expected, GameTeam.number_of_games_by_coach_for_season("20122013")
  end

  def test_it_can_get_all_wins_by_coach_for_a_season
    expected = {"John Tortorella"=>0, "Claude Julien"=>9, "Dan Bylsma"=>0, "Mike Babcock"=>0, "Joel Quenneville"=>1}
    assert_equal expected, GameTeam.find_all_wins_by_coach_for_season("20122013")
  end

  def test_it_can_get_percent_wins_by_coach_for_a_season
    assert_equal ({"John Tortorella"=>0.0, "Claude Julien"=>1.0, "Dan Bylsma"=>0.0, "Mike Babcock"=>0.0, "Joel Quenneville"=>1.0}),
    GameTeam.percent_wins_by_coach_for_season("20122013")
  end

  def test_it_can_get_winningest_coach
    assert_equal "Claude Julien", GameTeam.winningest_coach("20122013")
  end

  def test_it_can_get_worst_coach_for_a_season
    assert_equal "John Tortorella", GameTeam.worst_coach("20122013")
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

    assert_equal expected, GameTeam.goals_per_game_per_team
  end

  def test_it_can_find_all_game_teams_that_meet_a_condition
    assert_instance_of Array, GameTeam.find_all("game_id", "2012030224")
    assert_equal true, GameTeam.find_all("game_id", "2012030224").all? { |element| element.class == GameTeam}
    assert_equal 2, GameTeam.find_all("game_id", "2012030224").size
  end
end
