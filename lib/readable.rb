require 'csv'

module Readable

  def self.create(path, collection)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |row|
      collection << self.new(row.to_h)
    end
  end

end
