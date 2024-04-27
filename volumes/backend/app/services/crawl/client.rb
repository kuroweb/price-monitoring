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
          args: ["--blink-settings=imagesEnabled=false", "--disable-remote-fonts"]
        ) do |browser|
          page = browser.new_page
          page.route(/(\.css.*)/, ->(route, _) { route.abort })
          block.call(page)
        end
      end
    end
  end
end
