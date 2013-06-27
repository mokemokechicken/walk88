Fitbit.setup do |config|
  config[:oauth] = {
      consumer_key: SecretInfo['fitbit']['key'],
      consumer_secret: SecretInfo['fitbit']['secret'],
  }
end
