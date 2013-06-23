class Location < ActiveRecord::Base
  # @param [float] total_distance
  # @return [Location]
  def self.current_location(total_distance)
    Location.where('total_distance <= ?', total_distance).order('number desc').first
  end
end
