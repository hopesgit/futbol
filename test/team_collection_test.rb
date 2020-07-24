require 'minitest/autorun'
require 'minitest/pride'
require './lib/team_collection'

class TeamCollectionTest < Minitest::Test
    @@team_path = './data/teams.csv'
    @@team_collection = TeamCollection.new(@@team_path)

  def test_it_exists
    assert_instance_of TeamCollection, @@team_collection
  end

  def test_it_can_return_array_of_all_teams
    assert_instance_of Array, @@team_collection.all_teams
    assert_equal 32, @@team_collection.all_teams.size
    assert_equal true, @@team_collection.all_teams.all? { |team| team.class == Team }
  end
end