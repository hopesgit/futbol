class StatTracker

  def self.from_csv(data)
    #Read Data
    StatTracker.new(data)
  end

  def initialize(data)
    #Read Data
    #require "pry"; binding.pry
    @data = data
  end
end
