module Crawl
  class CamoufoxClient
    EXTRA_HTTP_HEADERS = {
      "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
      "Accept-Language" => "ja,en-US;q=0.9,en;q=0.8",
      "Upgrade-Insecure-Requests" => "1"
    }.freeze

    class << self
      def execute(proxy: nil)
        Playwright.connect_to_playwright_server(server_url) do |playwright|
          browser = playwright.firefox.launch(headless: true)
          context = browser.new_context(**context_options(proxy:))
          page = context.new_page
          setup_request_blocking!(page)
          yield(page)
        ensure
          safely_close(page)
          safely_close(context)
          safely_close(browser)
        end
      end

      def server_url
        ENV.fetch("CAMOUFOX_URL")
      end

      private

      def context_options(proxy:)
        options = {
          locale: "ja-JP",
          timezoneId: "Asia/Tokyo",
          userAgent: RequestBlocklist::USER_AGENT,
          extraHTTPHeaders: EXTRA_HTTP_HEADERS
        }
        return options unless proxy.present?

        options.merge(proxy:)
      end

      def setup_request_blocking!(page)
        page.route("**/*", lambda { |route, request|
          RequestBlocklist.blocked_request?(request.url) ? route.abort : route.fallback
        })
      end

      def safely_close(target)
        target&.close
      rescue StandardError
        nil
      end
    end
  end
end
