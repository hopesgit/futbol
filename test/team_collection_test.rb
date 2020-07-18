require "minitest/autorun"
require "minitest/pride"
require "./lib/team_collection"

class TeamCollectionTest < Minitest::Test

  def setup
    @team_collection = TeamCollection.new("./data/teams_fixture.csv")
  end

  def test_it_exists
    assert_instance_of TeamCollection, @team_collection
  end

  def test_it_can_return_array_of_all_teams
    teams = @team_collection.all

    assert_instance_of Array, teams
    assert_equal 2, teams.size 20

    assert_equal true, teams.all? { |team| team.class == Team }
  end
end
