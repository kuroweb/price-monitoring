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
    Crawl::Client.execute do |browser|
      page = browser.new_page
      page.goto("https://github.com/microsoft/playwright")
      page.eval_on_selector("link[rel=dns-prefetch]", "el => el.href")
    end
  end

  # private :product

  # def crawl_setting
  #   @crawl_setting ||= product.crawl_setting
  # end
end
