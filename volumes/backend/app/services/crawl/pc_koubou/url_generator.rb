module Crawl
  module PcKoubou
    class UrlGenerator
      BASE_URL = "https://www.pc-koubou.jp/user_data/search.php?".freeze
      KEYWORD = "q=".freeze
      PRICE_MIN = "n33l=".freeze
      PRICE_MAX = "n33h=".freeze

      def initialize(pc_koubou_crawl_setting:)
        @pc_koubou_crawl_setting = pc_koubou_crawl_setting
      end

      def generate
        url = BASE_URL
        url = keyword(url)
        url = price_min(url)
        url = price_max(url)
        url
      end

      attr_reader :pc_koubou_crawl_setting, :page

      def keyword(url)
        "#{url}#{KEYWORD}#{pc_koubou_crawl_setting.crawlable_keyword}&"
      end

      def price_min(url)
        "#{url}#{PRICE_MIN}#{pc_koubou_crawl_setting.min_price}&"
      end

      def price_max(url)
        "#{url}#{PRICE_MAX}#{pc_koubou_crawl_setting.max_price}"
      end
    end
  end
end
