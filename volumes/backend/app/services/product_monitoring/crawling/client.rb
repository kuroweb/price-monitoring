module ProductMonitoring
  module Crawling
    class Client
      USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) " \
                   "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36".freeze

      def self.execute(**, &)
        new(**).execute(&)
      end

      def initialize(block_scripts: false, user_agent: USER_AGENT, allow_script_host: nil, allow_images: false)
        @user_agent = user_agent
        @allow_script_host = allow_script_host
        @blocked_types = block_scripts ? %w[image font script] : %w[image font]
        @blocked_types -= %w[image] if allow_images
      end

      def execute
        proxy = Proxy.call
        Playwright.connect_to_browser_server(ENV.fetch("PLAYWRIGHT_URL"), browser_type: "chromium") do |browser|
          page = browser.new_context(userAgent: user_agent, proxy:).new_page
          page.route("**/*", ->(route, request) { blocked?(request) ? route.abort : route.fallback })
          yield page
        end
      end

      private

      attr_reader :user_agent, :allow_script_host, :blocked_types

      def blocked?(request)
        return true if blocked_types.include?(request.resource_type)

        RequestBlocklist.blocked?(request.url) && !allowed_script?(request)
      end

      def allowed_script?(request)
        allow_script_host.present? && request.resource_type == "script" &&
          URI.parse(request.url).host == allow_script_host
      end
    end
  end
end
