module Crawl
  module YahooAuction
    module SyncProduct
      class Crawler # rubocop:disable Metrics/ClassLength
        RETRY_COUNT = 3

        def self.call(...)
          new(...).call
        end

        def initialize(yahoo_auction_product:)
          @yahoo_auction_product = yahoo_auction_product
        end

        def call
          Crawl::Client.execute do |browser|
            page = browser.new_page

            Retryable.retryable(tries: RETRY_COUNT) do
              page.goto(url)
              load(page)
              deletable?(page) ? deletable_crawl_result : upsertable_crawl_result(page)
            end
          end
        end

        private

        attr_reader :yahoo_auction_product

        def url
          "https://page.auctions.yahoo.co.jp/jp/auction/#{yahoo_auction_product.yahoo_auction_id}"
        end

        def load(page)
          sleep(2)
          30.times do
            page.mouse.wheel(0, 200)
            sleep(0.005)
          end
        end

        # 個別クロール処理を実装中
        def deletable?(page)
          rejected?(page) || (closed?(page) && no_bids?(page))
        end

        def rejected?(page)
          page.query_selector("#modAlertBox strong:has-text('指定されたドキュメントは存在しません。')").present?
        end

        def closed?(page)
          page.query_selector(".ClosedHeader__tag").present?
        end

        def no_bids?(page)
          page.query_selector(".Count__detail").inner_text.to_i.zero?
        end

        def deletable_crawl_result # rubocop:disable Metrics/AbcSize
          crawl_result = CrawlResult.new(
            yahoo_auction_id: yahoo_auction_product.yahoo_auction_id,
            seller_id: yahoo_auction_product.seller_id,
            name: yahoo_auction_product.name,
            price: yahoo_auction_product.price,
            buyout_price: yahoo_auction_product.buyout_price,
            thumbnail_url: yahoo_auction_product.thumbnail_url,
            published: yahoo_auction_product.published,
            bought_date: yahoo_auction_product.bought_date,
            end_date: yahoo_auction_product.end_date,
            deletable: true
          )

          handle_errors(crawl_result)
          crawl_result
        end

        def upsertable_crawl_result(page)
          crawl_result = CrawlResult.new(
            yahoo_auction_id: yahoo_auction_product.yahoo_auction_id,
            seller_id: seller_id(page),
            name: name(page),
            price: price(page),
            buyout_price: buyout_price(page),
            thumbnail_url: thumbnail_url(page),
            published: published(page),
            bought_date: bought_date(page),
            end_date: end_date(page),
            deletable: false
          )

          handle_errors(crawl_result)
          crawl_result
        end

        def handle_errors(crawl_result)
          raise StandardError, crawl_result.errors.full_messages.join(", ") unless crawl_result.valid?
        end

        def seller_id(page)
          href = page.query_selector(".Seller__name >> a").get_attribute("href")
          href[%r{seller/([^/]+)}, 1]
        end

        def name(page)
          page.query_selector(".ProductTitle__text").inner_text
        end

        def price(page)
          price_str = page.query_selector_all(".Price__value")[0].inner_text
          price = price_str.match(/\d+,\d+/)[0].gsub(/,/, "").to_i
          tax_price = price_str.match(/(（税込 \d+,*\d+ 円）|（税 0 円）)/)[0].gsub(/（|）|,| |税込|円/, "").to_i

          tax_price.nonzero? || price
        end

        def buyout_price(page)
          price_index = page.query_selector_all(".Price__title").find_index { |title| title.inner_text == "即決" }
          return nil unless price_index

          price_str = page.query_selector_all(".Price__value")[price_index].inner_text
          price = price_str.match(/\d+,\d+/)[0].gsub(/,/, "").to_i
          tax_price = price_str.match(/(（税込 \d+,*\d+ 円）|（税 0 円）)/)[0].gsub(/（|）|,| |税込|円/, "").to_i

          tax_price.nonzero? || price
        end

        def thumbnail_url(page)
          page.query_selector(".ProductImage__inner > img").get_attribute("src")
        end

        def published(page)
          !closed?(page)
        end

        def bought_date(page)
          end_date(page)
        end

        def end_date(page)
          page.query_selector('.Section__table th:has-text("終了日時") + td').inner_text
        end
      end
    end
  end
end
