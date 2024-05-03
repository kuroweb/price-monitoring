module Crawl
  module Iosys
    class UrlGenerator
      BASE_URL = "https://iosys.co.jp/items?".freeze
      KEYWORD = "q=".freeze
      PRICE_MIN = "min=".freeze
      PRICE_MAX = "max=".freeze
      PAGE = "page=".freeze

      def initialize(iosys_crawl_setting:, page: 1)
        @iosys_crawl_setting = iosys_crawl_setting
        @page = page
      end

      def generate
        url = BASE_URL
        url = keyword(url)
        url = price_min(url)
        url = price_max(url)
        url = pagination(url)
        url
      end

      attr_reader :iosys_crawl_setting, :page

      def keyword(url)
        "#{url}#{KEYWORD}#{iosys_crawl_setting.crawlable_keyword}&"
      end

      def price_min(url)
        "#{url}#{PRICE_MIN}#{iosys_crawl_setting.min_price}&"
      end

      def price_max(url)
        "#{url}#{PRICE_MAX}#{iosys_crawl_setting.max_price}&"
      end

      def pagination(url)
        "#{url}#{PAGE}#{page}"
      end
    end
  end
end
