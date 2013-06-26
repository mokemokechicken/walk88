class Fitbit
  def self.setup
    @config ||= {}
    yield(@config)
  end

  def self.config
    @config ||= {}
    @config.dup
  end

  def self.create_client
    cfg = Fitgem::Client.symbolize_keys(config)
    Fitgem::Client.new(cfg[:oauth])
  end

  def self.fetch_info_by_day(client, day)
    begin
      data = client.activities_on_date day
      dist = data['summary']['distances'].select{|d| d['activity'] == 'total'}[0]['distance']
      step = data['summary']['steps']
      return {:dist => dist, :step => step}
    rescue Exception => e
      p e
    end
    return {:dist => 0, :step => 0, :error => true}
  end
end