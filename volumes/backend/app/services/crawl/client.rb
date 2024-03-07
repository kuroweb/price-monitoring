module Crawl
  class Client
    def self.execute(&block)
      Playwright.connect_to_playwright_server(ENV.fetch("PLAYWRIGHT_URL")) do |playwright|
        playwright.chromium.launch(
          headless: true,
          proxy: {
            server: ENV.fetch("PROXY_HOST"),
            username: ENV.fetch("PROXY_USERNAME"),
            password: ENV.fetch("PROXY_PASSWORD")
          },
          &block
        )
      end
    end
  end
end
