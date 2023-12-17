module Crawl
  class Client
    def self.execute(&block)
      Playwright.connect_to_playwright_server("ws://playwright:8888/ws") do |playwright|
        url = Rails.env.production? ? ENV.fetch("TOR_URL") : "socks5://tor#{rand(1..10)}:9050"

        playwright.chromium.launch(
          headless: true,
          proxy: { server: url },
          &block
        )
      end
    end
  end
end
