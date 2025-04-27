if Rails.env.production?
  require "opentracing"
  require "datadog/opentracer"
  require "ddtrace"

  Datadog.configure do |c|
    app = "price-monitoring"
    env = "production"

    c.env = env
    c.tracer tags: { app:, env: }

    c.tracing.instrument :rails, service_name: "#{app}-rails"
    c.tracing.instrument :rack, service_name: "#{app}-rack"
    c.tracing.instrument :sidekiq, service_name: "#{app}-sidekiq",
                                   client_service_name: "#{app}-sidekiq-client",
                                   tag_args: true
    c.tracing.instrument :mysql2, service_name: "#{app}-mysql"
    c.tracing.instrument :http, service_name: "#{app}-net/http"
    c.tracing.instrument :redis, service_name: "#{app}-redis"
  end
end
