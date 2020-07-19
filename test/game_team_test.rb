require 'minitest/autorun'
require 'minitest/pride'
require './lib/game_team'

class GameTeamTest < Minitest::Test
  def setup
    @game_team = GameTeam.new({
                                :game_id=>2012030221,
                                :team_id=>3,
                                :hoa=>"away",
                                :result=>"LOSS",
                                :settled_in=>"OT",
                                :head_coach=>"John Tortorella",
                                :goals=>2,
                                :shots=>8,
                                :tackles=>44,
                                :pim=>8,
                                :powerplayopportunities=>3,
                                :powerplaygoals=>0,
                                :faceoffwinpercentage=>44.8,
                                :giveaways=>17,
                                :takeaways=>7})
  end

  def test_it_exists
    assert_instance_of GameTeam, @game_team
  end
end
