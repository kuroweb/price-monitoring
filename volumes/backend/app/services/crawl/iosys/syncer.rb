module Crawl
  module Iosys
    class Syncer
      def self.call(...)
        new(...).call
      end

      def initialize(product:)
        @product = product
      end

      def call
        return unless iosys_crawl_setting.enabled?

        IosysProduct.transaction do
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

        IosysProduct.upsert_all(upsert_params, record_timestamps: true)
      end

      def delete
        IosysProduct.where(product_id: product.id)
                    .where.not(external_id: crawl_results.results.map(&:external_id))
                    .delete_all
      end

      def inspect
        Products::Inspect::DeleteIosysProducts.call(product:)
      end

      def iosys_crawl_setting
        @iosys_crawl_setting ||= product.iosys_crawl_setting
      end

      def crawl_results
        @crawl_results ||= Crawler.call(product:)
      end
    end
  end
end
