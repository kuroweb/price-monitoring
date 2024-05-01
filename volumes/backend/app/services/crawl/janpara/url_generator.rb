module Crawl
  module Janpara
    class UrlGenerator
      BASE_URL = "https://www.janpara.co.jp/sale/search/result/?".freeze
      KEYWORD = "KEYWORDS=".freeze
      PRICE_MIN = "MINPRICE=".freeze
      PRICE_MAX = "MAXPRICE=".freeze
      CONKBN = "CONKBN[]=7&CONKBN[]=6&CONKBN[]=8".freeze
      LINE = "LINE=100".freeze
      ORDER = "ORDER=1".freeze
      PAGE = "PAGE=".freeze

      def initialize(janpara_crawl_setting:, page: 0)
        @janpara_crawl_setting = janpara_crawl_setting
        @page = page
      end

      def generate
        url = BASE_URL
        url = keyword(url)
        url = price_min(url)
        url = price_max(url)
        url = conkbn(url)
        url = line(url)
        url = order(url)
        url = pagination(url)
        url
      end

      attr_reader :janpara_crawl_setting, :page

      def keyword(url)
        "#{url}#{KEYWORD}#{janpara_crawl_setting.crawlable_keyword}&"
      end

      def price_min(url)
        "#{url}#{PRICE_MIN}#{janpara_crawl_setting.min_price}&"
      end

      def price_max(url)
        "#{url}#{PRICE_MAX}#{janpara_crawl_setting.max_price}&"
      end

      def conkbn(url)
        "#{url}#{CONKBN}&"
      end

      def line(url)
        "#{url}#{LINE}&"
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
