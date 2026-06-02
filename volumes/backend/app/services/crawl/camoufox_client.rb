module Crawl
  class CamoufoxClient
    PROXY_INVALIDATION_STATUS_CODES = [403, 429].freeze

    class << self
      def execute
        Playwright.connect_to_playwright_server(server_url) do |playwright|
          browser = playwright.firefox.launch(headless: true)
          navigation = Navigation.new(browser:)

          begin
            yield(navigation)
          ensure
            navigation.close
          end
        end
      end

      def server_url
        ENV.fetch("CAMOUFOX_URL")
      end
    end

    class Navigation
      def initialize(browser:)
        @browser = browser
      end

      attr_reader :page

      def goto(url:)
        rotate_context!
        response = page.goto(url)
        invalidate_proxy_if_needed!(response)
        validate_response!(response)

        response
      end

      def close
        close_context
      end

      private

      attr_reader :browser, :proxy, :context

      def rotate_context!
        close_context
        @proxy = DynamicProxy.get
        @context = browser.new_context(**context_options)
        @page = context.new_page
        setup_request_blocking!
      end

      def context_options
        proxy.present? ? { proxy: } : {}
      end

      def setup_request_blocking!
        page.route("**/*", lambda { |route, request|
          RequestBlocklist.blocked_request?(request.url) ? route.abort : route.fallback
        })
      end

      def invalidate_proxy_if_needed!(response)
        return if proxy.blank?
        return if response.blank?

        status = response.status.to_i
        return unless PROXY_INVALIDATION_STATUS_CODES.include?(status)

        DynamicProxy.remove(proxy:)
      end

      def validate_response!(response)
        status = response&.status.to_i
        return if status.between?(200, 299)

        raise StandardError, "request failed: #{status}"
      end

      def close_context
        page&.close
        context&.close
        @page = nil
        @context = nil
        @proxy = nil
      end
    end
  end
end
