module Crawl
  class Client
    MERCARI_BLOCKED_LIST = [".css", "common.json", "mypage.json", "seo.json", "search.json", "validation.json",
                            "sell.json", "brand.json", "user.json", "www.google.com", "googletagmanager.com",
                            "securepubads.g.doubleclick.net", "sentry.io"].freeze

    YAHOO_AUCTION_BLOCKED_LIST = ["yads.c.yimg.jp", "yads.yjtag.yahoo.co.jp", "www.googleadservices.com",
                                  "static.criteo.net", "clb.yahoo.co.jp", "mhd.yahoo.co.jp", "s.yimg.jp",
                                  "yjtag.yahoo.co.jp", "s.yjtag.jp", "facebook.net"].freeze

    def self.execute(&block) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      server, username, password = Proxy.get

      Playwright.connect_to_playwright_server(ENV.fetch("PLAYWRIGHT_URL")) do |playwright|
        playwright.chromium.launch(
          headless: true,
          proxy: { server:, username:, password: },
          args: ["--blink-settings=imagesEnabled=false", "--disable-remote-fonts"]
        ) do |browser|
          page = browser.new_page

          page.route(
            "**/*",
            lambda { |route, request|
              return route.abort if MERCARI_BLOCKED_LIST.any? { |url| request.url.include?(url) }
              return route.abort if YAHOO_AUCTION_BLOCKED_LIST.any? { |url| request.url.include?(url) }

              route.fallback
            }
          )

          block.call(page)
        end
      end
    end
  end
end
