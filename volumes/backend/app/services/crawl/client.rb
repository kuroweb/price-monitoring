module Crawl
  class Client
    class << self
      def execute(block_scripts: false, user_agent: RequestBlocklist::USER_AGENT, allow_script_host: nil)
        Playwright.connect_to_browser_server(server_url, browser_type: "chromium") do |browser|
          context = browser.new_context(**context_options(user_agent:))
          page = context.new_page
          page.route("**/*", lambda { |route, request|
            blocked?(request, block_scripts:, allow_script_host:) ? route.abort : route.fallback
          })
          yield(page)
        end
      end

      def blocked?(request, block_scripts:, allow_script_host:)
        blocked_request = RequestBlocklist.blocked_request?(request.url)
        if request.resource_type == "script" && allow_script_host && URI.parse(request.url).host == allow_script_host
          blocked_request = false
        end
        blocked_types = block_scripts ? %w[image font script] : %w[image font]
        blocked_request || blocked_types.include?(request.resource_type)
      end

      def context_options(user_agent:)
        { userAgent: user_agent, proxy: DynamicProxy.get }
      end

      def server_url
        ENV.fetch("PLAYWRIGHT_URL")
      end
    end
  end
end
