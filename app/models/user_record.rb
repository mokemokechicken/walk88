class UserRecord < ActiveRecord::Base
  belongs_to :user

  def self.weekly_records(user_id, params=nil)
    query = UserRecord.where(user_id: user_id).order(:day)
    weeks = []
    week = []
    query.each do |rec|
      if week.size > 0 && rec.day.wday == 0
        weeks << week
        week = []
      end
      week << rec
    end
    weeks << week if week.size > 0
    weeks.map do |week|
      h = {
          week: week[0].day.to_s,
          step: (1.0 * week.map{|d| d.steps}.sum / week.size).to_i,
          distance: 1.0 * week.map{|d| d.distance}.sum,
      }
    end
  end
end
