module Crawl
  class CamoufoxClient
    class << self
      def execute
        Playwright.connect_to_playwright_server(server_url) do |playwright|
          browser = playwright.firefox.launch(headless: true)
          context = browser.new_context(**context_options)
          page = context.new_page
          page.route("**/*", ->(route, request) { RequestBlocklist.blocked_request?(request.url) ? route.abort : route.fallback })
          yield(page)
        end
      end

      def context_options
        { proxy: Proxy.get }
      end

      def server_url
        ENV.fetch("CAMOUFOX_URL")
      end
    end
  end
end
