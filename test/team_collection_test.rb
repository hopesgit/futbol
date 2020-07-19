require 'minitest/autorun'
require 'minitest/pride'
require './lib/team_collection'

class TeamCollectionTest < Minitest::Test
  def setup
    @team_path = './data/teams_fixture.csv'
    @team_collection = TeamCollection.new(@team_path)
  end

  def test_it_exists
    assert_instance_of TeamCollection, @team_collection
  end

  def test_it_can_return_array_of_all_teams
    @team_collection.create_teams
    
    assert_instance_of Array, @team_collection.teams
    assert_equal 20, @team_collection.teams.size

    assert_equal true, @team_collection.teams.all? { |team| team.class == Team }
  end
end
