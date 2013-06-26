class Fitbit
  @@config = {}
  KM_PER_MILE = 1.609344

  def self.setup
    yield(@@config)
  end

  def self.config
    @@config.dup
  end

  def self.create_client
    cfg = Fitgem::Client.symbolize_keys(config)
    Fitgem::Client.new(cfg[:oauth])
  end

  def self.fetch_info_by_day(client, day)
      data = client.activities_on_date day
      unless data['errors']
        dist = data['summary']['distances'].select{|d| d['activity'] == 'total'}[0]['distance']
        step = data['summary']['steps']
        return {:dist => dist.to_s.to_f * KM_PER_MILE, :step => step}
      else
        return {:dist => 0, :step => 0, :errors => data['errors']}
      end
  end
end