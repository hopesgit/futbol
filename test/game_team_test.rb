require './test/helper_test'
require './lib/game_team'

class GameTeamTest < Minitest::Test

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
    GameTeam.create('./data/game_teams_fixture.csv')
    assert_instance_of Array, GameTeam.class_variable_get(:@@all_game_teams)
    assert_equal 60, GameTeam.class_variable_get(:@@all_game_teams).count
    assert_equal true, GameTeam.class_variable_get(:@@all_game_teams).all? { |game_team| game_team.class == GameTeam }
  end

  def test_it_can_add_season_id
    GameTeam.create('./data/game_teams_fixture.csv')
    assert_equal "20122013", GameTeam.class_variable_get(:@@all_game_teams)[1].season
    assert_equal "20172018",  GameTeam.class_variable_get(:@@all_game_teams)[59].season
  end

  def test_it_can_generate_a_season_id
    assert_equal "20122013", @game_team.generate_season("2012030225")
    assert_equal "20142015", @game_team.generate_season("2014030413")
  end
end
