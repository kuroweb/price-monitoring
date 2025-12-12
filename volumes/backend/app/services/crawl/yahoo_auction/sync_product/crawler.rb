module Crawl
  module YahooAuction
    module SyncProduct
      class Crawler
        RETRY_COUNT = 3

        def self.call(...)
          new(...).call
        end

        def initialize(yahoo_auction_product:)
          @yahoo_auction_product = yahoo_auction_product
        end

        def call
          Crawl::Client.execute do |page|
            Retryable.retryable(tries: RETRY_COUNT) do
              page.goto(url)
              json = item_json(page)
              deletable?(json) ? deletable_crawl_result : upsertable_crawl_result(json)
            end
          end
        end

        private

        attr_reader :yahoo_auction_product

        def url
          "https://page.auctions.yahoo.co.jp/jp/auction/#{yahoo_auction_product.external_id}"
        end

        def item_json(page)
          script_content = page.eval_on_selector("#__NEXT_DATA__", "el => el.textContent")
          json = JSON.parse(script_content)
          json.dig("props", "pageProps", "initialState", "item") || {}
        end

        def deletable?(json)
          rejected?(json) || (!open?(json) && no_bids?(json))
        end

        def rejected?(json)
          json["fetchItemDetailError"].present?
        end

        def open?(json)
          status = json.dig("detail", "item", "status")
          status == "open"
        end

        def no_bids?(json)
          json.dig("detail", "item", "bids").zero?
        end

        def deletable_crawl_result # rubocop:disable Metrics/AbcSize
          crawl_result = CrawlResult.new(
            external_id: yahoo_auction_product.external_id,
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

        def upsertable_crawl_result(json)
          crawl_result = CrawlResult.new(
            external_id: yahoo_auction_product.external_id,
            seller_id: seller_id(json),
            name: name(json),
            price: price(json),
            buyout_price: buyout_price(json),
            thumbnail_url: thumbnail_url(json),
            published: open?(json),
            bought_date: end_date(json),
            end_date: end_date(json),
            deletable: false
          )

          handle_errors(crawl_result)
          crawl_result
        end

        def handle_errors(crawl_result)
          raise StandardError, crawl_result.errors.full_messages.join(", ") unless crawl_result.valid?
        end

        def seller_id(json)
          json.dig("detail", "item", "seller", "aucUserId")
        end

        def name(json)
          json.dig("detail", "item", "title")
        end

        def price(json)
          json.dig("detail", "item", "price")
        end

        def buyout_price(json)
          json.dig("detail", "item", "bidorbuy")
        end

        def thumbnail_url(json)
          json.dig("detail", "item", "img")&.first&.[]("thumbnail")
        end

        def end_date(json)
          json.dig("detail", "item", "endTime")
        end
      end
    end
  end
end
