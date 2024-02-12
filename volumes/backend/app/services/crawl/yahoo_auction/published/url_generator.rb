module Crawl
  module YahooAuction
    module Published
      class UrlGenerator
        BASE_URL = "https://auctions.yahoo.co.jp/search/search?".freeze
        CATEGORY = "auccat=".freeze
        KEYWORD_1 = "p=".freeze
        KEYWORD_2 = "va=".freeze
        MIN_PRICE_1 = "min=".freeze
        MIN_PRICE_2 = "aucminprice=".freeze
        MAX_PRICE_1 = "max=".freeze
        MAX_PRICE_2 = "aucmaxprice=".freeze
        PRICE_TYPE = "price_type=currentprice".freeze
        PRODUCT_STATUS = "istatus=0".freeze
        POSTAGE_MODE = "is_postage_mode=0".freeze
        DESTINATION_CODE = "dest_pref_code=0".freeze
        DISPLAY_MODE = "mode=2".freeze
        DISPLAY_START = "b=".freeze
        DISPLAY_RANGE = "n=100".freeze
        DISPLAY_ORDER = "s1=new&o1=d".freeze

        def initialize(yahoo_auction_crawl_setting:, start: 1)
          @yahoo_auction_crawl_setting = yahoo_auction_crawl_setting
          @start = start
        end

        def generate # rubocop:disable Metrics/AbcSize
          url = BASE_URL
          url = category(url)
          url = keyword(url)
          url = min_price(url)
          url = max_price(url)
          url = price_type(url)
          url = product_status(url)
          url = postage_mode(url)
          url = destination_code(url)
          url = display_mode(url)
          url = display_start(url)
          url = display_range(url)
          url = display_order(url)
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

        def price_type(url)
          "#{url}#{PRICE_TYPE}&"
        end

        def product_status(url)
          "#{url}#{PRODUCT_STATUS}&"
        end

        def postage_mode(url)
          "#{url}#{POSTAGE_MODE}&"
        end

        def destination_code(url)
          "#{url}#{DESTINATION_CODE}&"
        end

        def display_mode(url)
          "#{url}#{DISPLAY_MODE}&"
        end

        def display_start(url)
          "#{url}#{DISPLAY_START}#{start}&"
        end

        def display_range(url)
          "#{url}#{DISPLAY_RANGE}&"
        end

        def display_order(url)
          "#{url}#{DISPLAY_ORDER}"
        end
      end
    end
  end
end
