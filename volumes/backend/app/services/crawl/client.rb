module Crawl
  class Client
    COMMON_BLOCKED_LIST = %w[.css].freeze

    MERCARI_BLOCKED_LIST = %w[
      common.json
      mypage.json
      seo.json
      search.json
      validation.json
      sell.json
      brand.json
      user.json
      www.google.com
      googletagmanager.com
      securepubads.g.doubleclick.net
      sentry.io
    ].freeze

    YAHOO_AUCTION_BLOCKED_LIST = %w[
      yads.c.yimg.jp
      yads.yjtag.yahoo.co.jp
      www.googleadservices.com
      static.criteo.net
      clb.yahoo.co.jp
      mhd.yahoo.co.jp
      s.yimg.jp
      yjtag.yahoo.co.jp
      s.yjtag.jp
      facebook.net
    ].freeze

    JANPARA_BLOCKED_LIST = %w[
      www.janpara.co.jp/javascripts
      www.janpara.co.jp/common
      www.janpara.co.jp/poplink
      apis.google.com
      m.geniee-search.net
      pagead2.googlesyndication.com
      flux-cdn.com
    ].freeze

    IOSYS_BLOCKED_LIST = %w[
      www.google-analytics.com
      checkout-api.worldshopping.jp
      statics.a8.net
    ].freeze

    USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) " \
                 "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36".freeze

    class << self
      def execute(&block)
        Playwright.connect_to_playwright_server(ENV.fetch("PLAYWRIGHT_URL")) do |playwright|
          playwright.chromium.launch(**launch_options) do |browser|
            browser.new_context(**context_options) do |context|
              page = context.new_page
              page.route("**/*", ->(route, request) { blocked_request?(request.url) ? route.abort : route.fallback })
              block.call(page)
            end
          end
        end
      end

      def launch_options
        {
          headless: true,
          args: ["--blink-settings=imagesEnabled=false", "--disable-remote-fonts"]
        }
      end

      def context_options
        # server, username, password = Proxy.get

        {
          userAgent: USER_AGENT,
          # proxy: { server:, username:, password: }
          proxy: {
            server: ENV.fetch("PROXY_HOST"),
            username: ENV.fetch("PROXY_USERNAME"),
            password: ENV.fetch("PROXY_PASSWORD")
          }
        }
      end

      def blocked_request?(url)
        blocked_url?(COMMON_BLOCKED_LIST, url) \
          || blocked_url?(MERCARI_BLOCKED_LIST, url) \
          || blocked_url?(YAHOO_AUCTION_BLOCKED_LIST, url) \
          || blocked_url?(JANPARA_BLOCKED_LIST, url) \
          || blocked_url?(IOSYS_BLOCKED_LIST, url)
      end

      def blocked_url?(blocked_list, url)
        blocked_list.any? { |blocked_url| url.include?(blocked_url) }
      end
    end
  end
end
