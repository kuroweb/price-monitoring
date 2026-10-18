module Crawl
  module Backmarket
    class Syncer
      def self.call(...)
        new(...).call
      end

      def initialize(backmarket_watch_target:)
        @backmarket_watch_target = backmarket_watch_target
      end

      def call
        return unless backmarket_watch_target.enabled?

        current_result = ResultCreator.call(backmarket_watch_target:, crawl_result:)
        return if current_result.blank?

        DiffNotifier.call(backmarket_watch_target:, current_result:)
      end

      private

      attr_reader :backmarket_watch_target

      def crawl_result
        @crawl_result ||= Crawler.call(backmarket_watch_target:)
      end
    end
  end
end
