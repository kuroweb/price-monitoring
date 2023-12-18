Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") }

  config_hash = YAML.load_file(File.join(Rails.root, "config", "sidekiq.yml"))
  config[:concurrency] = config_hash[Rails.env][:concurrency]
end
