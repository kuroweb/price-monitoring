if Rails.env.production?
  require "ddtrace"

  Datadog.configure do |c|
    app = "price-monitoring"
    env = "production"

    c.env = env
    c.tags = { app:, env: }

    c.tracing.instrument :rails, service_name: app
    c.tracing.instrument :sidekiq, service_name: "#{app}-sidekiq",
                                   client_service_name: "#{app}-sidekiq-client",
                                   tag_args: true
    c.tracing.instrument :active_record, service_name: "#{app}-mysql"
    c.tracing.instrument :http, service_name: "#{app}-http"
    c.tracing.instrument :redis, service_name: "#{app}-redis",
                                 peer_service: "#{app}-redis"
  end
end
