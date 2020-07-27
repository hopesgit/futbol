require 'minitest/autorun'
require 'minitest/pride'
require './lib/team'

class TeamTest < MiniTest::Test
  def setup
    @team = Team.new({team_id: "1", franchiseid: "23", teamname: "Atlanta United", abbreviation: "ATL", stadium: "Mercedes-Benz Stadium", link: "/api/v1/teams/1"})
    Team.class_variable_set(:@@all_teams, [])
  end

  def test_it_exists
    assert_instance_of Team, @team
  end

  def test_it_has_readable_attributes
    assert_equal "1", @team.id
    assert_equal "23", @team.franchise_id
    assert_equal "Atlanta United", @team.name
    assert_equal "ATL", @team.abbreviation
    assert_equal "/api/v1/teams/1", @team.link
  end

  def test_it_can_return_an_array_of_info
    Team.create('./data/teams.csv') 
    assert_equal 32, Team.class_variable_get(:@@all_teams).count
    assert_equal true, Team.class_variable_get(:@@all_teams).all? { |team| team.class == Team }
  end
end
