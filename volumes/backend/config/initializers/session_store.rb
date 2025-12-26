# frozen_string_literal: true

Rails.application.config.session_store(
  :redis_session_store,
  key: "_price_monitoring_session",
  redis: {
    url: ENV.fetch("REDIS_URL", nil)
  },
  namespace: "session",
  expire_after: 24.hours.to_i,
  secure: Rails.env.production?,
  same_site: :lax,
  httponly: true
)
