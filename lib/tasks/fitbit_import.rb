class FitbitImport
  require 'date'

  def self.execute(from_date='2013-06-01')
    new.start(Settings.fitbit.fetch_past_days, from_date)
  end

  def start(days_ago, from_date)
    Date.today.downto(Date.today - days_ago).each do |date|
      import(date) if Date.parse(from_date) <= date
    end
  end

  def import(date)
    UserSetting.all.each do |setting|
      begin
        if setting.exist_fitbit_token?
          client = Fitbit.create_client
          record = UserRecord.find_by(user_id: setting.user_id, day: date)
          client.reconnect(setting.fitbit_token, setting.fitbit_secret)
          info = Fitbit.fetch_info_by_day(client, date.to_s)
          p info
          if record
            if record.steps < info[:step].to_s.to_i
              record.update_attributes({
                                           steps: info[:step].to_s.to_i,
                                           distance: info[:dist].to_s.to_f
                                       })
              UserStatus.update_user_status(setting.user_id)
            end
          else
            record = UserRecord.create({
                                           user_id: setting.user_id,
                                           day: date,
                                           steps: info[:step].to_s.to_i,
                                           distance: info[:dist].to_s.to_f
                                       })
            UserStatus.update_user_status(setting.user_id)
          end
          p record
          sleep 1
        end
      rescue Exception => ex
        p ex
      end
    end
  end

  def parse_date(day_str)
    case day_str
      when 'today' then Date.today
      when 'yesterday' then Date.yesterday
      else Date.parse(day)
    end
  end
end