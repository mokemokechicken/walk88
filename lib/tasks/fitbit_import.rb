class FitbitImport
  def self.execute(day='today,yesterday')
    new.start(day)
  end

  def start(days)
    day_list = days.split(/,/)
    day_list.each do |day|
      date = parse_date(day)
      import(date)
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
            end
          else
            record = UserRecord.create({
                user_id: setting.user_id,
                day: date,
                steps: info[:step].to_s.to_i,
                distance: info[:dist].to_s.to_f
                              })
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