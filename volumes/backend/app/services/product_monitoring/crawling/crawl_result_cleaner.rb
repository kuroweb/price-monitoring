module ProductMonitoring
  module Crawling
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
