# 開催中のオークション画面のクローラ
module Crawl
  module YahooFleamarket
    module SyncProducts
      module Published
        class Crawler
          RETRY_COUNT = 5
          MAX_SIZE = 500

          def initialize(product:)
            @product = product
          end

          def execute # rubocop:disable Metrics/MethodLength
            Crawl::Client.execute do |page|
              start = 1
              loop do
                break if start > MAX_SIZE

                Retryable.retryable(tries: RETRY_COUNT) do
                  page.goto(url(start))
                  page.reload
                  break if no_results?(page)

                  append_results(page)
                end

                break unless exists_next_page?(page)

                start += 100
              end
            end

            raise StandardError, crawl_results.errors unless crawl_results.valid?

            crawl_results
          end

          private

          attr_reader :product

          def append_results(page)
            product_doms = page.query_selector_all("li.Product")
            product_doms.each do |dom|
              result = Crawl::YahooFleamarket::SyncProducts::CrawlResult.new(
                yahoo_fleamarket_id: yahoo_fleamarket_id(dom),
                seller_id: seller_id(dom),
                name: name(dom),
                price: price(dom),
                thumbnail_url: thumbnail_url(dom),
                published: true,
                bought_date: nil
              )

              crawl_results.add(result)
            end
          end

          def url(start)
            UrlGenerator.new(yahoo_auction_crawl_setting: product.yahoo_auction_crawl_setting, start:).generate
          end

          def no_results?(page)
            page.query_selector(".Notice__wandQuery")
          end

          def exists_next_page?(page)
            page.query_selector(".Pager__list.Pager__list--next > a.Pager__link")
          end

          def yahoo_fleamarket_id(dom)
            dom.query_selector(".Product__titleLink").get_attribute("data-auction-id")
          end

          def seller_id(dom)
            href = dom.query_selector(".Product__sellerLink").get_attribute("href")
            href[%r{user/([^/]+)}, 1]
          end

          def name(dom)
            dom.query_selector(".Product__titleLink").inner_text
          end

          def price(dom)
            dom.query_selector_all(".Product__priceValue")[0].inner_text.gsub(/,|円/, "")
          end

          def thumbnail_url(dom)
            dom.eval_on_selector(".Product__imageData", "el => el.src")
          end

          def crawl_results
            @crawl_results ||= Crawl::YahooFleamarket::SyncProducts::CrawlResults.new
          end
        end
      end
    end
  end
end
