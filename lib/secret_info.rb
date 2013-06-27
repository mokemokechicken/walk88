class SecretInfo
  def self.secret_file
    File.expand_path('../../config/secrets/' + Rails.env + '/secrets.json', __FILE__)
  end

  def self.secrets
    @secrets ||= JSON.parse(File.read(self.secret_file))
  end

  def self.[](key)
    self.secrets[key]
  end
end