module Helpable

  def total_games_per_team(exclude_hoa = nil)
    GameTeam.all.reduce(Hash.new(0)) do |result, game_team|
      result[game_team.team_id] += 1 unless game_team.hoa == exclude_hoa
      result
    end
  end

  def total_goals_per_team(exclude_hoa = nil)
    GameTeam.all.reduce(Hash.new(0)) do |result, game_team|
      result[game_team.team_id] += game_team.goals unless game_team.hoa == exclude_hoa
      result
    end
  end

  def average_goals_per_game_per_team(exclude_hoa = nil)
    Team.all.reduce({}) do |result, team|
      average = (total_goals_per_team(exclude_hoa)[team.id] / total_games_per_team(exclude_hoa)[team.id].to_f).round(2)
      result[team] = average unless average.nan?
      result
    end
  end

  def find_team(team_id)
    Team.all.find { |team| team.id == team_id }
  end

  def tackles_per_team_for(season_id)
    GameTeam.all.reduce(Hash.new(0)) do |result, game_team|
      result[find_team(game_team.team_id).name] += game_team.tackles if game_team.season == season_id
      result
    end
  end

  def games_for_team(team_id)
    Game.all.select {|game| game.away_team_id == team_id || game.home_team_id == team_id}
  end

  def opponent_by_game_id_for_team(team_id)
    games_for_team(team_id).reduce({}) do |result, game|
      result[game.game_id] = [game.away_team_id, game.home_team_id].select {|id| id != team_id}.join
      result
      end
  end

  def games_won_per_team
    GameTeam.all.reduce(Hash.new(0)) do |result, game_team|
      result[game_team.team_id] += 0
      result[game_team.team_id] += 1 if game_team.result == "WIN"
      result
    end
  end

  def game_result?(result, team_id, game_id)
    game = GameTeam.all.find { |game_team| game_team.game_id == game_id && game_team.team_id == team_id }
    game.result == result
  end

  def opponents_and_opponents_num_result_for_team(team_id, game_result)
    opponent_by_game_id_for_team(team_id).reduce(Hash.new(0)) do |result, game_id_oppo_ary|
      result[game_id_oppo_ary[1]] += 0
      result[game_id_oppo_ary[1]] += 1 if game_result?(game_result, game_id_oppo_ary[1], game_id_oppo_ary[0])
      result
    end
  end

  def total_games_per_team_per_season(season_id)
    GameTeam.all.reduce(Hash.new(0)) do |result, game_team|
      result[game_team.team_id] += 1 if game_team.season == season_id
      result
    end
  end

  def win_percentage_per_team
    games_won_per_team.merge(total_games_per_team){|team_id, wins, games| (wins.to_f / games).round(2)}
  end

  def games_won_per_team_for_season(season_id)
    GameTeam.all.reduce(Hash.new(0)) do |result, game_team|
      result[game_team.team_id] += 1 if game_team.season == season_id &&  game_team.result == "WIN"
      result
    end
  end

  def num_games_per_opponent_for_team(team_id)
    opponent_by_game_id_for_team(team_id).each_with_object(Hash.new(0)) do |(game_id, team_ID), result|
      result[team_ID] += 1 if team_ID == team_ID
    end
  end

  def opponents_and_opponent_win_percent_for_team(team_id)
    opponents_and_opponents_num_result_for_team(team_id, "WIN").merge(num_games_per_opponent_for_team(team_id)){|team_ID, wins, games| (wins.to_f / games).round(2)}
  end


  def win_percentage_per_team_per_season
    Game.all_seasons.reduce(Hash.new { |h,k| h[k] = {} }) do |result, season|
     result[season] = games_won_per_team_for_season(season).merge(total_games_per_team_per_season(season)) do |team_id, wins, games|
      (wins.to_f / games).round(2)
     end
     result
    end
  end
end
