module Crawl
  class Client
    def self.execute(&block)
      Playwright.connect_to_playwright_server(ENV.fetch("PLAYWRIGHT_URL")) do |playwright|
        # TODO: ローカル環境での指定方法を改善する
        url = Rails.env.production? ? ENV.fetch("TOR_URL") : "socks5://backend-tor-#{rand(1..5)}:9050"

        playwright.chromium.launch(
          headless: true,
          proxy: { server: url },
          &block
        )
      end
    end
  end
end
