if Rails.env.production?
  require "ddtrace"

  Datadog.configure do |c|
    app = "price-monitoring"
    env = "production"

    c.service = app
    c.env = env
    c.tags = { app:, env: }

    c.tracing.instrument :rails, service_name: app
    c.tracing.instrument :sidekiq, service_name: "#{app}-sidekiq",
                                   peer_service: "#{app}-sidekiq",
                                   client_service_name: "#{app}-sidekiq-client",
                                   tag_args: true,
                                   on_job_span: lambda { |span, _job, *_args|
                                                  span.set_tag("peer.messaging.system", nil)
                                                }
    c.tracing.instrument :active_record, service_name: "#{app}-mysql"
    c.tracing.instrument :http, service_name: "#{app}-http"
    c.tracing.instrument :redis, service_name: "#{app}-redis",
                                 peer_service: "#{app}-redis"
  end
end
