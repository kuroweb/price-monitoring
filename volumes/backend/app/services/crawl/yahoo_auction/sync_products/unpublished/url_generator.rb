# 落札相場画面のクローラ用のURLジェネレータ
module Crawl
  module YahooAuction
    module SyncProducts
      module Unpublished
        class UrlGenerator
          BASE_URL = "https://auctions.yahoo.co.jp/closedsearch/closedsearch?".freeze
          CATEGORY = "auccat=".freeze
          KEYWORD_1 = "p=".freeze
          KEYWORD_2 = "va=".freeze
          MIN_PRICE_1 = "min=".freeze
          MIN_PRICE_2 = "aucminprice=".freeze
          MAX_PRICE_1 = "max=".freeze
          MAX_PRICE_2 = "aucmaxprice=".freeze
          PRODUCT_STATUS = "istatus=0".freeze
          DISPLAY_START = "b=".freeze
          DISPLAY_RANGE = "n=100".freeze

          def initialize(yahoo_auction_crawl_setting:, start: 1)
            @yahoo_auction_crawl_setting = yahoo_auction_crawl_setting
            @start = start
          end

          def generate
            url = BASE_URL
            url = category(url)
            url = keyword(url)
            url = min_price(url)
            url = max_price(url)
            url = product_status(url)
            url = display_start(url)
            url = display_range(url)
            url
          end

          private

          attr_reader :yahoo_auction_crawl_setting, :start

          def category(url)
            "#{url}#{CATEGORY}#{yahoo_auction_crawl_setting.category_id}&"
          end

          def keyword(url)
            "#{url}#{KEYWORD_1}#{yahoo_auction_crawl_setting.crawlable_keyword}&" \
            "#{KEYWORD_2}#{yahoo_auction_crawl_setting.crawlable_keyword}&"
          end

          def min_price(url)
            "#{url}#{MIN_PRICE_1}#{yahoo_auction_crawl_setting.min_price}&#{MIN_PRICE_2}" \
            "#{yahoo_auction_crawl_setting.min_price}&"
          end

          def max_price(url)
            "#{url}#{MAX_PRICE_1}#{yahoo_auction_crawl_setting.max_price}&#{MAX_PRICE_2}" \
            "#{yahoo_auction_crawl_setting.max_price}&"
          end

          def product_status(url)
            "#{url}#{PRODUCT_STATUS}&"
          end

          def display_start(url)
            "#{url}#{DISPLAY_START}#{start}&"
          end

          def display_range(url)
            "#{url}#{DISPLAY_RANGE}&"
          end
        end
      end
    end
  end
end
