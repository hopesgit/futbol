class GameTeam

attr_reader :game_id,
            :team_id,
            :hoa,
            :result,
            :settled_in,
            :head_coach,
            :goals,
            :shots,
            :tackles,
            :pim,
            :powerplay_opportunities,
            :powerplay_goals,
            :faceoff_win_percentage,
            :giveaways,
            :takeaways

attr_accessor :season

  def initialize(data)
    @game_id = data[:game_id]
    @team_id = data[:team_id]
    @hoa = data[:hoa]
    @result = data[:result]
    @settled_in = data[:settled_in]
    @head_coach = data[:head_coach]
    @goals = data[:goals]
    @shots = data[:shots]
    @tackles = data[:tackles]
    @pim = data[:pim]
    @powerplay_opportunities = data[:powerplayopportunities]
    @powerplay_goals = data[:powerplaygoals]
    @faceoff_win_percentage = data[:faceoffwinpercentage]
    @giveaways = data[:giveaways]
    @takeaways = data[:takeaways]
    @season = nil
  end
end
