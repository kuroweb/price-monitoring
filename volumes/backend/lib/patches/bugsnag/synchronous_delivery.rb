module Patches
  module Bugsnag
    # Bugsnag::Delivery::Synchronous#deliver の拡張（notify 成功後に Discord 通知）
    module SynchronousDelivery
      def deliver(url, body, configuration, options = {})
        response = request(url, body, configuration, options)
        configuration.debug("Request to #{url} completed, status: #{response.code}")

        if response.code.start_with?("2")
          Discord::BugsnagNotifier.call(payload: body, event_id: response["bugsnag-event-id"])
        else
          configuration.warn(
            "Notifications to #{url} was reported unsuccessful with code #{response.code}"
          )
        end
      rescue StandardError => e
        configuration.error("Unable to send information to BugSnag (#{url}), #{e.inspect}")
        configuration.error(e.backtrace)
      end
    end
  end
end
