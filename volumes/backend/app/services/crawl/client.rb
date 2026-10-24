module Crawl
  class Client
    class << self
      def execute
        Playwright.connect_to_browser_server(server_url, browser_type: "chromium") do |browser|
          context = browser.new_context(**context_options)
          page = context.new_page
          page.route("**/*", lambda { |route, request|
            blocked_request = RequestBlocklist.blocked_request?(request.url)
            blocked_resource = %w[image font].include?(request.resource_type)
            blocked_request || blocked_resource ? route.abort : route.fallback
          })
          yield(page)
        end
      end

      def context_options
        { userAgent: RequestBlocklist::USER_AGENT, proxy: Proxy.get }
      end

      def server_url
        ENV.fetch("PLAYWRIGHT_URL")
      end
    end
  end
end
