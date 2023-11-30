module Crawl
  class Client
    def self.execute(&block)
      Playwright.connect_to_playwright_server("ws://playwright:8888/ws") do |playwright|
        playwright.chromium.launch(
          headless: true,
          proxy: { server: "socks5://tor:9050" },
          &block
        )
      end
    end
  end
end
