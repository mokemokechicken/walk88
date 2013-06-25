class FitbitImport
  def self.execute(day='yesterday')
    date = case day
             when 'today' then Date.today
             when 'yesterday' then Date.yesterday
             else Date.parse(day)
           end

    UserSetting.all.each do |setting|
      begin
        if !setting.fitbit_token.to_s.empty? && !setting.fitbit_secret.to_s.empty?
          client = Fitbit.create_client
          record = UserRecord.find_by(user_id: setting.user_id, day: date)
          client.reconnect(setting.fitbit_token, setting.fitbit_secret)
          info = Fitbit.fetch_info_by_day(client, day)
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
end