module Crawl
  module Backmarket
    class Syncer
      COMPARISON_ATTRIBUTES = %w[
        name
        price
        condition
        memory
        storage
        cpu
        stock_status
      ].freeze

      def self.call(...)
        new(...).call
      end

      def initialize(backmarket_watch_target:)
        @backmarket_watch_target = backmarket_watch_target
      end

      def call
        return unless backmarket_watch_target.enabled?

        result = crawler_result
        create_result!(result) unless unchanged?(result)
      end

      private

      attr_reader :backmarket_watch_target

      def create_result!(result)
        backmarket_watch_target.backmarket_watch_results.create!(
          result.attributes.merge("crawled_at" => Time.current)
        )
      end

      def unchanged?(result)
        return false if latest_result.blank?

        COMPARISON_ATTRIBUTES.all? do |attribute|
          latest_result.public_send(attribute) == result.public_send(attribute)
        end
      end

      def latest_result
        @latest_result ||= backmarket_watch_target.backmarket_watch_results.order(crawled_at: :desc).first
      end

      def crawler_result
        @crawler_result ||= Crawler.call(backmarket_watch_target:)
      end
    end
  end
end
