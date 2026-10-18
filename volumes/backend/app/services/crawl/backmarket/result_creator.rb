module Crawl
  module Backmarket
    class ResultCreator
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

      def initialize(backmarket_watch_target:, crawl_result:)
        @backmarket_watch_target = backmarket_watch_target
        @crawl_result = crawl_result
      end

      def call
        return if unchanged?

        create_result!
      end

      private

      attr_reader :backmarket_watch_target, :crawl_result

      def previous_result
        @previous_result ||= backmarket_watch_target.backmarket_watch_results.order(crawled_at: :desc).first
      end

      def unchanged?
        return false if previous_result.blank?

        COMPARISON_ATTRIBUTES.all? do |attribute|
          previous_result.public_send(attribute) == crawl_result.public_send(attribute)
        end
      end

      def create_result!
        backmarket_watch_target.backmarket_watch_results.create!(
          crawl_result.attributes.merge("crawled_at" => Time.current)
        )
      end
    end
  end
end
