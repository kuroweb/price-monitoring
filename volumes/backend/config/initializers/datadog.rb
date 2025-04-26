if Rails.env.production?
  require "opentracing"
  require "datadog/opentracer"
  require "ddtrace"

  # Activate the Datadog tracer for OpenTracing
  OpenTracing.global_tracer = Datadog::OpenTracer::Tracer.new

  Datadog.configure do |c|
    c.env = "production"

    c.tracing.instrument :rails, service_name: "price-monitoring-rails"
    c.tracing.instrument :rack, service_name: "price-monitoring-rack"
    c.tracing.instrument :sidekiq, service_name: "price-monitoring-sidekiq"
    c.tracing.instrument :mysql2, service_name: "price-monitoring-mysql"
    c.tracing.instrument :http, service_name: "price-monitoring-http"
    c.tracing.instrument :redis, service_name: "price-monitoring-redis"
  end
end
