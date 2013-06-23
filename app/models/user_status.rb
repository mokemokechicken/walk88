class UserStatus < ActiveRecord::Base
  belongs_to :location
  belongs_to :next_location, :foreign_key => 'next_location_id', :class_name => 'Location'
  belongs_to :user


  # @param [User] user
  # @return [UserStatus]
  def self.init(user)
    model = self.new(user_id: user.id)
    model.update_user_status
  end

  def self.update_user_status(user_id)
    us = UserStatus.find_by(user_id: user_id)
    if us
      us.update_user_status
    end
    us
  end

  # @return [UserStatus]
  def update_user_status
    rec = UserRecord.where(user_id: user_id).select('sum(steps) as steps, sum(distance) as distance').first
    last_day = UserRecord.where(user_id: user_id).maximum(:day)
    self.total_step = rec.steps || 0
    self.total_distance = rec.distance || 0
    self.last_walk_day = last_day
    cl = Location.current_location(total_distance)
    self.location_id = cl.id
    nl = Location.find_by(number: cl.number+1)
    if nl
      self.next_location_id = nl.id
      self.next_distance = cl.next_distance - (total_distance - cl.total_distance)
      progress = self.next_distance / cl.next_distance
      self.lat = cl.lat * (1-progress) + nl.lat * progress
      self.lon = cl.lon * (1-progress) + nl.lon * progress
    end
    save
    self
  end
end
