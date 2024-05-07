module Utils
  module TimeoutHandler
    JOB_TIMEOUT = 30.minutes

    def handle_timeout(time = JOB_TIMEOUT, &block)
      Timeout.timeout(time, &block)
    rescue Timeout::Error => e
      Rails.logger.error("This job has reached timeout.")
      raise e
    end
  end
end
