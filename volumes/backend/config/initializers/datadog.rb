if Rails.env.production?
  require "opentracing"
  require "datadog/opentracer"
  require "ddtrace"

  # Activate the Datadog tracer for OpenTracing
  OpenTracing.global_tracer = Datadog::OpenTracer::Tracer.new

  Datadog.configure do |c|
    c.env = "production"
    c.service = "price-monitoring"

    c.tracing.instrument :rails
    c.tracing.instrument :rack
    c.tracing.instrument :sidekiq
  end
end
