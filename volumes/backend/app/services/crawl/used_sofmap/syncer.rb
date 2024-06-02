module Crawl
  module UsedSofmap
    class Syncer
      def self.call(...)
        new(...).call
      end

      def initialize(product:)
        @product = product
      end

      def call
        return unless used_sofmap_crawl_setting.enabled?

        UsedSofmapProduct.transaction do
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

        UsedSofmapProduct.upsert_all(upsert_params, record_timestamps: true)
      end

      def delete
        UsedSofmapProduct.where(product_id: product.id)
                         .where.not(external_id: crawl_results.results.map(&:external_id))
                         .delete_all
      end

      def inspect
        Products::Inspect::DeleteUsedSofmapProducts.call(product:)
      end

      def used_sofmap_crawl_setting
        @used_sofmap_crawl_setting ||= product.used_sofmap_crawl_setting
      end

      def crawl_results
        @crawl_results ||= Crawler.call(product:)
      end
    end
  end
end
