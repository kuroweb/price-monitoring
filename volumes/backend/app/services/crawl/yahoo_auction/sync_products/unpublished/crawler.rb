# 落札相場画面のクローラ
module Crawl
  module YahooAuction
    module SyncProducts
      module Unpublished
        class Crawler
          RETRY_COUNT = 5
          MAX_SIZE = 500

          def initialize(product:)
            @product = product
          end

          def execute
            Crawl::Client.execute do |page|
              start = 1
              loop do
                break if start > MAX_SIZE

                Retryable.retryable(tries: RETRY_COUNT) do
                  page.goto(url(start))
                  break if not_exist_results?(page)

                  append_results(page)
                end

                break if stop?(page)

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
              result = Crawl::YahooAuction::SyncProducts::CrawlResult.new(
                external_id: external_id(dom),
                seller_id: seller_id(dom),
                name: name(dom),
                price: price(dom),
                buyout_price: nil,
                thumbnail_url: thumbnail_url(dom),
                published: false,
                bought_date: bought_date(dom),
                end_date: end_date(dom)
              )

              crawl_results.add(result)
            end
          end

          def url(start)
            UrlGenerator.new(yahoo_auction_crawl_setting: product.yahoo_auction_crawl_setting, start:).generate
          end

          def stop?(page)
            not_exist_results?(page) || not_exist_next_page?(page)
          end

          def not_exist_results?(page)
            page.query_selector(".Notice__wandQuery")
          end

          def not_exist_next_page?(page)
            !page.query_selector(".Pager__list.Pager__list--next > a.Pager__link")
          end

          def external_id(dom)
            dom.query_selector(".Product__titleLink").get_attribute("href").split("/")[-1]
          end

          def seller_id(dom)
            href = dom.query_selector(".Product__sellerLink").get_attribute("href")
            href[%r{seller/([^/]+)}, 1]
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

          def bought_date(dom)
            date_str = dom.query_selector(".Product__time").inner_text
            datetime = date_str.to_datetime
            datetime > Time.current ? datetime.ago(1.year) : datetime
          end

          def end_date(dom)
            bought_date(dom)
          end

          def crawl_results
            @crawl_results ||= Crawl::YahooAuction::SyncProducts::CrawlResults.new
          end
        end
      end
    end
  end
end
