module ProductMonitoring
  module Crawling
    # 保存済みの商品計測結果のうち、現在の条件に一致しないものを除外済みの行も含めて削除する
    class CrawlResultCleaner
      def self.call(...)
        new(...).call
      end

      def initialize(product_crawl_setting:)
        @product_crawl_setting = product_crawl_setting
      end

      def call
        ids = ProductCrawlResult.where(product_crawl_setting_id: product_crawl_setting.id).filter_map do |result|
          result.id unless CrawlSettings::Matcher.call(product_crawl_setting:, listing: result)
        end
        ProductCrawlResult.where(id: ids).delete_all if ids.any?
      end

      private

      attr_reader :product_crawl_setting
    end
  end
end
