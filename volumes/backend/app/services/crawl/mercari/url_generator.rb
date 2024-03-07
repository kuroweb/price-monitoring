module Crawl
  module Mercari
    class UrlGenerator
      BASE_URL = "https://jp.mercari.com/search?".freeze
      KEYWORD = "keyword=".freeze
      CATEGORY = "category_id=".freeze
      PRICE_MIN = "price_min=".freeze
      PRICE_MAX = "price_max=".freeze
      ORDER = "sort=created_time&order=desc".freeze
      PAGE = "page_token=v1:".freeze

      def initialize(mercari_crawl_setting:, page: 0)
        @mercari_crawl_setting = mercari_crawl_setting
        @page = page
      end

      def generate
        url = BASE_URL
        url = keyword(url)
        url = category(url)
        url = price_min(url)
        url = price_max(url)
        url = order(url)
        url = pagination(url)
        url
      end

      attr_reader :mercari_crawl_setting, :page

      def keyword(url)
        "#{url}#{KEYWORD}#{mercari_crawl_setting.crawlable_keyword}&"
      end

      def category(url)
        "#{url}#{CATEGORY}#{mercari_crawl_setting.category_id}&"
      end

      def price_min(url)
        "#{url}#{PRICE_MIN}#{mercari_crawl_setting.min_price}&"
      end

      def price_max(url)
        "#{url}#{PRICE_MAX}#{mercari_crawl_setting.max_price}&"
      end

      def order(url)
        "#{url}#{ORDER}&"
      end

      def pagination(url)
        "#{url}#{PAGE}#{page}"
      end
    end
  end
end
