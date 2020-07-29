require 'csv'

class DataSet
  def self.create(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |row|
      object = new(row.to_h)
      all << object
      if object.class == GameTeam
        object.season = object.generate_season(object.game_id)
      end
    end
  end

  def generate_season(game_id)
    "#{game_id.slice(0, 4)}#{(game_id.slice(0, 4)).to_i + 1}"
  end

  def self.count
    all.count
  end

  def self.find(attribute, value)
    all.find { |element| element.send(attribute) == value }
  end

  def self.find_all(attribute, value)
    all.find_all { |element| element.send(attribute) == value }
  end
end
