# スクレイピングするサービスクラス
# 一旦ベタ書きで実装したのちにリファクタする予定
class CrawlService
  def self.call(...)
    new(...).call
  end

  # def initialize(product:)
  #   @product = product
  # end

  def call
    Playwright.connect_to_playwright_server("ws://playwright:8888/ws") do |playwright|
      playwright.chromium.launch do |browser|
        page = browser.new_page
        page.goto("https://github.com/microsoft/playwright")
        page.screenshot(path: "github-microsoft-playwright.png")
      end
    end
  end

  # private :product

  # def crawl_setting
  #   @crawl_setting ||= product.crawl_setting
  # end
end
