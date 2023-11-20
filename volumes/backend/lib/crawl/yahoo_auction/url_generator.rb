module Crawl
  module YahooAuction
    class UrlGenerator
      BASE_URL = "https://auctions.yahoo.co.jp/search/search".freeze
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

      def initialize(product:, start: 1)
        @product = product
        @start = start
      end

      def generate # rubocop:disable Metrics/AbcSize
        url = base_url("")
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

      attr_reader :product, :start

      def crawl_setting
        @crawl_setting ||= product.yahoo_auction_crawl_setting
      end

      def base_url(str)
        "#{str}#{BASE_URL}?"
      end

      def category(str)
        "#{str}#{CATEGORY}#{crawl_setting.category_id}&"
      end

      def keyword(str)
        "#{str}#{KEYWORD_1}#{product.crawlable_name}&#{KEYWORD_2}#{product.crawlable_name}&"
      end

      def min_price(str)
        "#{str}#{MIN_PRICE_1}#{crawl_setting.min_price}&#{MIN_PRICE_2}#{crawl_setting.min_price}&"
      end

      def max_price(str)
        "#{str}#{MAX_PRICE_1}#{crawl_setting.max_price}&#{MAX_PRICE_2}#{crawl_setting.max_price}&"
      end

      def price_type(str)
        "#{str}#{PRICE_TYPE}&"
      end

      def product_status(str)
        "#{str}#{PRODUCT_STATUS}&"
      end

      def postage_mode(str)
        "#{str}#{POSTAGE_MODE}&"
      end

      def destination_code(str)
        "#{str}#{DESTINATION_CODE}&"
      end

      def display_mode(str)
        "#{str}#{DISPLAY_MODE}&"
      end

      def display_start(str)
        "#{str}#{DISPLAY_START}#{start}&"
      end

      def display_range(str)
        "#{str}#{DISPLAY_RANGE}&"
      end

      def display_order(str)
        "#{str}#{DISPLAY_ORDER}"
      end
    end
  end
end
