module ProductMonitoring
  module Crawling
    # 保存済みの収集結果のうち、現在の保存条件に一致しないものを除外済みの行も含めて削除する
    class CrawlResultCleaner
      def self.call(...)
        new(...).call
      end

      def initialize(crawl_setting:)
        @crawl_setting = crawl_setting
      end

      def call
        ids = ProductMonitoring::CrawlResult.where(crawl_setting_id: crawl_setting.id).filter_map do |result|
          result.id unless CrawlSetting::Matcher.call(crawl_setting:, listing: result)
        end
        ProductMonitoring::CrawlResult.where(id: ids).delete_all if ids.any?
      end

      private

      attr_reader :crawl_setting
    end
  end
end
