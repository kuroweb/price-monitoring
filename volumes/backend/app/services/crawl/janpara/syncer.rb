module Crawl
  module Janpara
    class Syncer
      def self.call(...)
        new(...).call
      end

      def initialize(product:)
        @product = product
      end

      def call
        return unless janpara_crawl_setting.enabled?

        JanparaProduct.transaction do
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

        JanparaProduct.upsert_all(upsert_params, record_timestamps: true)
      end

      def delete
        JanparaProduct.where.not(janpara_id: crawl_results.results.map(&:janpara_id))
                      .delete_all
      end

      def inspect
        Inspect.call(product:)
      end

      def janpara_crawl_setting
        @janpara_crawl_setting ||= product.janpara_crawl_setting
      end

      def crawl_results
        @crawl_results ||= Crawler.call(product:)
      end
    end
  end
end
