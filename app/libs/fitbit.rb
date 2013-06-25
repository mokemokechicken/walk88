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
end