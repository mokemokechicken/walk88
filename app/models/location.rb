class Location < ActiveRecord::Base
  # @param [float] total_distance
  # @return [Location]
  def self.current_location(total_distance)
    Location.where('total_distance <= ?', total_distance).order('number desc').first
  end

  def self.reverse_current_location(total_distance)
    Location.where("#{Location.max_total_distance} - total_distance <= ?", total_distance).order('number').first
  end

  def self.max_total_distance
    Location.select('max(total_distance) as total_distance').first.total_distance
  end
end
