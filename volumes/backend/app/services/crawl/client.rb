module Crawl
  class Client
    COMMON_BLOCKED_LIST = [".css"].freeze
    MERCARI_BLOCKED_LIST = [
      "common.json", "mypage.json", "seo.json", "search.json", "validation.json", "sell.json", "brand.json",
      "user.json", "www.google.com", "googletagmanager.com", "securepubads.g.doubleclick.net", "sentry.io"
    ].freeze
    YAHOO_AUCTION_BLOCKED_LIST = [
      "yads.c.yimg.jp", "yads.yjtag.yahoo.co.jp", "www.googleadservices.com", "static.criteo.net", "clb.yahoo.co.jp",
      "mhd.yahoo.co.jp", "s.yimg.jp", "yjtag.yahoo.co.jp", "s.yjtag.jp", "facebook.net"
    ].freeze
    JANPARA_BLOCKED_LIST = [
      "https://www.janpara.co.jp/javascripts", "https://www.janpara.co.jp/common", "https://www.janpara.co.jp/poplink",
      "apis.google.com", "m.geniee-search.net", "pagead2.googlesyndication.com", "flux-cdn.com"
    ].freeze

    UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) " \
         "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36".freeze

    def self.execute(&block) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      server, username, password = Proxy.get

      Playwright.connect_to_playwright_server(ENV.fetch("PLAYWRIGHT_URL")) do |playwright|
        playwright.chromium.launch(
          headless: true,
          proxy: { server:, username:, password: },
          args: ["--blink-settings=imagesEnabled=false", "--disable-remote-fonts"]
        ) do |browser|
          browser.new_context(
            userAgent: UA
          ) do |context|
            page = context.new_page

            page.route(
              "**/*",
              lambda { |route, request|
                return route.abort if COMMON_BLOCKED_LIST.any? { |url| request.url.include?(url) }
                return route.abort if MERCARI_BLOCKED_LIST.any? { |url| request.url.include?(url) }
                return route.abort if YAHOO_AUCTION_BLOCKED_LIST.any? { |url| request.url.include?(url) }
                return route.abort if JANPARA_BLOCKED_LIST.any? { |url| request.url.include?(url) }

                route.fallback
              }
            )

            block.call(page)
          end
        end
      end
    end
  end
end
