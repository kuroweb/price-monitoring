if Rails.env.production?
  require "ddtrace"

  Datadog.configure do |c|
    app = "price-monitoring"
    env = "production"

    c.service = app
    c.env = env
    c.tags = { app:, env: }

    c.tracing.instrument :rails, service_name: "#{app}-rails"
    c.tracing.instrument :sidekiq, service_name: "#{app}-sidekiq",
                                   client_service_name: "#{app}-sidekiq-client",
                                   tag_args: true
    c.tracing.instrument :http, service_name: "#{app}-net/http"
    c.tracing.instrument :redis, service_name: "#{app}-redis"
  end
end
