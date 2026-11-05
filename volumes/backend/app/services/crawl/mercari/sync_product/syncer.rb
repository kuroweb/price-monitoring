module Crawl
  module Mercari
    module SyncProduct
      class Syncer
        def self.call(...)
          new(...).call
        end

        def initialize(mercari_product:)
          @mercari_product = mercari_product
        end

        def call
          return unless mercari_crawl_setting.enabled?

          crawl_result.deleted ? delete : update
        end

        private

        attr_reader :mercari_product

        def update
          mercari_product.update(crawl_result.attributes.except("deleted"))
        end

        def delete
          mercari_product.destroy
        end

        def mercari_crawl_setting
          @mercari_crawl_setting ||= mercari_product.product.mercari_crawl_setting
        end

        def crawl_result
          @crawl_result ||= Crawler.call(mercari_product:)
        end
      end
    end
  end
end
