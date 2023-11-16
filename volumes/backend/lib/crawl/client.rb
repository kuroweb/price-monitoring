module Crawl
  class Client
    def self.execute(&block)
      Playwright.connect_to_playwright_server("ws://playwright:8888/ws") do |playwright|
        playwright.chromium.launch(&block)
      end
    end
  end
end
