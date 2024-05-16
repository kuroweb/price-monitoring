module Crawl
  module PcKoubou
    class Syncer
      def self.call(...)
        new(...).call
      end

      def initialize(product:)
        @product = product
      end

      def call
        return unless pc_koubou_crawl_setting.enabled?

        PcKoubouProduct.transaction do
          upsert
          delete
          inspect
        end
      end

      private

      attr_reader :product

      def upsert
        upsert_params = crawl_results.results.map do |result|
          result.attributes.merge("product_id" => product.id)
        end

        PcKoubouProduct.upsert_all(upsert_params, record_timestamps: true)
      end

      def delete
        PcKoubouProduct.where(product_id: product.id)
                       .where.not(external_id: crawl_results.results.map(&:external_id))
                       .delete_all
      end

      def inspect
        Inspect.call(product:)
      end

      def pc_koubou_crawl_setting
        @pc_koubou_crawl_setting ||= product.pc_koubou_crawl_setting
      end

      def crawl_results
        @crawl_results ||= Crawler.call(product:)
      end
    end
  end
end
