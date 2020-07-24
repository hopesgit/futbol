require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'
require './lib/game_collection'

class GameCollectionTest < Minitest::Test
  @@game_path = './data/games_fixture.csv'
  @@game_collection = GameCollection.new(@@game_path)

  def test_it_exists
    assert_instance_of GameCollection, @@game_collection
  end

  def test_it_can_return_an_array_of_info
    @@game_collection.all_games
    assert_instance_of Array, @@game_collection.all_games

    assert_equal 30, @@game_collection.all_games.count

    assert_equal true, @@game_collection.all_games.all? { |game| game.class == Game }
  end

  def test_it_can_generate_a_hash_of_all_game_ids_by_season 
    # skip
    # expected = {
    #             20122013=>[2012030221, 2012030222, 2012030223, 2012030224, 2012030225, 2012030311, 2012030312, 2012030313, 2012030314, 2012030231],
    #             20142015=>[2014030411, 2014030412, 2014030413, 2014030414, 2014030415, 2014030416, 2014030131, 2014030132, 2014030133, 2014030134],
    #             20172018=>[2017030241, 2017030242, 2017030243, 2017030244, 2017030245, 2017030246, 2017030181, 2017030182, 2017030183, 2017030184]
    #           }
    expected = {
      "20122013"=>["2012030221", "2012030222", "2012030223", "2012030224", "2012030225", "2012030311", "2012030312", "2012030313", "2012030314", "2012030231"],
      "20142015"=>["2014030411", "2014030412", "2014030413", "2014030414", "2014030415", "2014030416", "2014030131", "2014030132", "2014030133", "2014030134"],
      "20172018"=>["2017030241", "2017030242", "2017030243", "2017030244", "2017030245", "2017030246", "2017030181", "2017030182", "2017030183", "2017030184"]
    }

    assert_equal expected, @@game_collection.all_gameids_per_season
  end
end
