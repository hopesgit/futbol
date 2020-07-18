class StatTracker
  attr_reader :game_path,
              :team_path,
              :game_teams_path

  def self.from_csv(data)
    game_path = data[:games]
    team_path = data[:teams]
    game_teams_path = data[:game_teams]
    StatTracker.new(game_path, team_path, game_teams_path)
  end

  def initialize(game_path, team_path, game_teams_path)
    @game_path = game_path
    @team_path = team_path
    @game_teams_path = game_teams_path
    # @team_collection = TeamCollection.new(team_path)
    # @game_collection = GameCollection.new(game_path, game_teams_path)
  end
end
