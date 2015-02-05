class Fitbit
  KM_PER_MILE = 1.609344

  def self.create_client
    config = {}
    config[:oauth] = {
        consumer_key: ENV['FITBIT_KEY'],
        consumer_secret: ENV['FITBIT_SECRET'],
    }
    cfg = Fitgem::Client.symbolize_keys(config)
    Fitgem::Client.new(cfg[:oauth])
  end

  def self.fetch_info_by_day(client, day)
      data = client.activities_on_date day
      unless data['errors']
        step = data['summary']['steps']
        if Settings.use_fix_step_length
          dist = step * Settings.use_fix_step_length / 1000 # meter -> KM
        else
          dist = data['summary']['distances'].select{|d| d['activity'] == 'total'}[0]['distance']
          dist = dist.to_s.to_f * KM_PER_MILE
        end
        return {:dist => dist, :step => step}
      else
        return {:dist => 0, :step => 0, :errors => data['errors']}
      end
  end
end