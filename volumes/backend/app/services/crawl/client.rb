module Crawl
  class Client
    class << self
      def execute(block_scripts: false)
        Playwright.connect_to_browser_server(server_url, browser_type: "chromium") do |browser|
          context = browser.new_context(**context_options)
          page = context.new_page
          page.route("**/*", lambda { |route, request|
            blocked_request = RequestBlocklist.blocked_request?(request.url)
            blocked_types = block_scripts ? %w[image font script] : %w[image font]
            blocked_resource = blocked_types.include?(request.resource_type)
            blocked_request || blocked_resource ? route.abort : route.fallback
          })
          yield(page)
        end
      end

      def context_options
        { userAgent: RequestBlocklist::USER_AGENT, proxy: DynamicProxy.get }
      end

      def server_url
        ENV.fetch("PLAYWRIGHT_URL")
      end
    end
  end
end
