require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'

class GameTest < Minitest::Test

  def setup
    @game = Game.new({:game_id => "2012030221", :season => "20122013", :type => "Postseason", :date_time => "5/16/13", :away_team_id => "3", :home_team_id => "6", :away_goals => 2, :home_goals => 3, :venue => "Toyota Stadium", :venue_link => "/api/v1/venues/null"})
    Game.class_variable_set(:@@all_games, [])
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_it_can_read_info
    assert_equal "2012030221", @game.game_id
    assert_equal "20122013", @game.season
    assert_equal "Postseason", @game.type
    assert_equal "5/16/13", @game.date_time
    assert_equal "3", @game.away_team_id
    assert_equal "6", @game.home_team_id
    assert_equal 2, @game.away_goals
    assert_equal 3, @game.home_goals
  end

  def test_it_can_return_an_array_of_info
    Game.create('./data/games_fixture.csv')
    assert_instance_of Array, Game.class_variable_get(:@@all_games)
    assert_equal 30, Game.class_variable_get(:@@all_games).count
    assert_equal true, Game.class_variable_get(:@@all_games).all? { |game| game.class == Game }
  end

  def test_it_can_get_total_number_of_games
    Game.create('./data/games_fixture.csv')
    assert_equal 30, Game.count
  end

  def test_it_can_find_a_game
    Game.create('./data/games_fixture.csv')

    assert_instance_of Game, Game.find("game_id", "2012030222")
    assert_equal 2, Game.find("game_id", "2012030222").away_goals
  end

  def test_it_can_find_all_games_in_a_season
    Game.create('./data/games_fixture.csv')

    assert_instance_of Array, Game.find_all("season", "20172018")
    assert_equal true, Game.find_all("season", "20172018").all? { |element| element.class == Game}
    assert_equal 10, Game.find_all("season", "20172018").size
  end
end
