module Crawl
  module UsedSofmap
    class UrlGenerator
      BASE_URL = "https://used.sofmap.com/r/item?".freeze
      KEYWORD = "q=".freeze
      PRICE_MIN = "min_price=".freeze
      PRICE_MAX = "max_price=".freeze
      PAGE = "page=".freeze

      def initialize(used_sofmap_crawl_setting:, page: 1)
        @used_sofmap_crawl_setting = used_sofmap_crawl_setting
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

      attr_reader :used_sofmap_crawl_setting, :page

      def keyword(url)
        "#{url}#{KEYWORD}#{used_sofmap_crawl_setting.crawlable_keyword}&"
      end

      def price_min(url)
        "#{url}#{PRICE_MIN}#{used_sofmap_crawl_setting.min_price}&"
      end

      def price_max(url)
        "#{url}#{PRICE_MAX}#{used_sofmap_crawl_setting.max_price}&"
      end

      def pagination(url)
        "#{url}#{PAGE}#{page}"
      end
    end
  end
end
