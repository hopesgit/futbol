require 'minitest/autorun'
require 'minitest/pride'
require './lib/team'

class TeamTest < MiniTest::Test
  def setup
    @team = Team.new({team_id: 1, franchiseid: 23, teamname: "Atlanta United", abbreviation: "ATL", stadium: "Mercedes-Benz Stadium", link: "/api/v1/teams/1"})
  end

  def test_it_exists
    assert_instance_of Team, @team
  end

  def test_it_has_readable_attributes
    assert_equal 1, @team.id
    assert_equal 23, @team.franchise_id
    assert_equal "Atlanta United", @team.name
    assert_equal "ATL", @team.abbreviation
    assert_equal "Mercedes-Benz Stadium", @team.stadium
    assert_equal "/api/v1/teams/1", @team.link
  end
end
