require 'minitest/autorun'
require 'minitest/pride'
require './lib/team'

class TeamTest < MiniTest::Test
  def setup
    @team = Team.new({id: })
  end

  def test_it_exists
    assert_instance_of Team, @team
  end
end


    @merchant = Merchant.new({:id => 5, :name => "Turing School"})
  end


@abbreviation="ATL",
 @id=nil,
 @link="/api/v1/teams/1",
 @name="Atlanta United",
 @stadium="Mercedes-Benz Stadium">,
