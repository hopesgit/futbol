require 'csv'

class DataSet
  def self.create(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |row|
      all << new(row.to_h)
    end
  end

  def self.count
    all.count
  end
end
