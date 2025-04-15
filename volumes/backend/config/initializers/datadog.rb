if Rails.env.production?
  require 'opentracing'
  require 'datadog/opentracer'
  require 'ddtrace'

  # Activate the Datadog tracer for OpenTracing
  OpenTracing.global_tracer = Datadog::OpenTracer::Tracer.new

  Datadog.configure do |c|
    c.env = 'production'
    c.service = 'price-monitoring'
    c.tracing.transport_options = proc do |t|
      # TODO: hostnameをENVに切り出す
      t.adapter :net_http, timeout: 1, hostname: 'datadog-agent.datadog.svc.cluster.local', port: 8126
    end
  end
end
