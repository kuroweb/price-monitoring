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

          crawl_result = Crawler.call(mercari_product:)
          save(crawl_result)
        end

        private

        attr_reader :mercari_product

        def save(crawl_result)
          if crawl_result.deleted
            mercari_product.destroy
          else
            mercari_product.update(crawl_result.attributes.except("deleted"))
          end
        end

        def mercari_crawl_setting
          @mercari_crawl_setting ||= mercari_product.product.mercari_crawl_setting
        end
      end
    end
  end
end
