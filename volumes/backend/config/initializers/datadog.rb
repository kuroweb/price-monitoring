if Rails.env.production?
  require "ddtrace"

  Datadog.configure do |c|
    app = "price-monitoring"
    env = "production"

    c.service = app
    c.env = env
    c.tags = { app:, env: }

    c.tracing.instrument :rails
    c.tracing.instrument :sidekiq, tag_args: true
    c.tracing.instrument :active_record
    c.tracing.instrument :http
    c.tracing.instrument :redis
  end
end
