module Crawl
  module Mercari
    class Crawler
      def initialize(product:)
        @product = product
      end

      def execute
        Crawl::Client.execute do |browser|
          page = browser.new_page

          start = 0
          page.goto(url(start))
          page.reload

          iframe = page.frame_locator("//iframe[@title='Widget containing a Cloudflare security challenge']")
          checkbox = iframe.get_by_role("checkbox")

          # TODO: メルカリはproxy経由でのスクレイピングが不可能（Torがダメ）

          loop do
            page.screenshot(path: "./hoge.png")
            checkbox.click if checkbox.visible?

            sleep(0.3)
          end
        end
      end

      attr_reader :product

      def url(start)
        Crawl::Mercari::UrlGenerator.new(
          mercari_crawl_setting: product.mercari_crawl_setting, page: start
        ).generate
      end

      def no_results?(page); end

      def exists_next_page?(page); end

      def loop_safe(start)
        start > 100
      end

      def product_doms(page)
        page.query_selector_all("li.item-cell")
      end
    end
  end
end
