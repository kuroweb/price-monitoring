# 開催中のオークション画面のクローラ
module Crawl
  module YahooAuction
    module Published
      class Crawler
        def initialize(product:)
          @product = product
        end

        def execute
          Crawl::Client.execute do |browser|
            page = browser.new_page

            start = 1
            loop do
              page.goto(url(start))
              append_results(page)

              break unless exists_next_page?(page)
              break if loop_safe(start)

              start += 100
            end
          end

          crawl_results
        end

        private

        attr_reader :product

        def append_results(page)
          product_doms = page.query_selector_all("li.Product")
          product_doms.each do |dom|
            result = Crawl::YahooAuction::CrawlResult.new(
              yahoo_auction_id: yahoo_auction_id(dom),
              name: name(dom),
              price: price(dom),
              thumbnail_url: thumbnail_url(dom),
              published: true,
              canceled: false
            )
            crawl_results.add(result)
          end
        end

        def url(start)
          Crawl::YahooAuction::Published::UrlGenerator.new(
            yahoo_auction_crawl_setting: product.yahoo_auction_crawl_setting, start:
          ).generate
        end

        def exists_next_page?(page)
          page.query_selector(".Pager__list.Pager__list--next > a.Pager__link")
        end

        def loop_safe(start)
          start > 100_000
        end

        def yahoo_auction_id(dom)
          dom.query_selector(".Product__titleLink").get_attribute("data-auction-id")
        end

        def name(dom)
          dom.query_selector(".Product__titleLink").inner_text
        end

        def price(dom)
          dom.query_selector(".Product__priceValue").inner_text.gsub(/,|円/, "")
        end

        def thumbnail_url(dom)
          dom.eval_on_selector(".Product__imageData", "el => el.src")
        end

        def crawl_results
          @crawl_results ||= Crawl::YahooAuction::CrawlResults.new
        end
      end
    end
  end
end