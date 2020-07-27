class Game
  attr_reader :game_id,
              :season,
              :type,
              :date_time,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals
  @@all_games = []

  def initialize(info)
    @game_id = info[:game_id]
    @season = info[:season]
    @type = info[:type]
    @date_time = info[:date_time]
    @away_team_id = info[:away_team_id]
    @home_team_id = info[:home_team_id]
    @away_goals = info[:away_goals].to_i
    @home_goals = info[:home_goals].to_i
  end

  def self.create_games(game_path)
    CSV.foreach(game_path, headers: true, header_converters: :symbol) do |row|
      @@all_games << Game.new(row.to_h)
    end
  end

end
